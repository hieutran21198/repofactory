import importlib.util
import json
import sys
import tempfile
import threading
import unittest
import urllib.error
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "_assets" / "project-issues" / "notify.py"
SPEC = importlib.util.spec_from_file_location("artifact_issue_notify", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def result(artifacts=None):
    return {
        "repository": "owner/repository",
        "pullRequest": {
            "number": 21,
            "title": "Accept artifacts",
            "url": "https://github.example/owner/repository/pull/21",
        },
        "artifacts": artifacts if artifacts is not None else [
            {
                "change": "added",
                "path": "docs/artifact/feat-login/README.md",
                "url": "https://tracker.example/one",
            },
            {
                "change": "renamed",
                "path": "docs/artifact/feat-login/tasks/task-new.md",
                "previousPath": "docs/artifact/feat-login/tasks/task-old.md",
                "url": "https://tracker.example/two",
            },
        ],
    }


class Response:
    status = 200

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def getcode(self):
        return self.status


class NotificationTest(unittest.TestCase):
    def test_load_result_checks_required_artifact_values(self):
        invalid = result([{"change": "renamed", "path": "new", "url": "https://tracker"}])
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "result.json"
            path.write_text(json.dumps(invalid))
            with self.assertRaisesRegex(RuntimeError, "previousPath"):
                MODULE.load_result(str(path))

    def test_build_message_lists_changes_and_links(self):
        message = MODULE.build_message(result())
        self.assertIn("owner/repository#21", message)
        self.assertIn("ADDED: docs/artifact/feat-login/README.md", message)
        self.assertIn("task-old.md -> docs/artifact/feat-login/tasks/task-new.md", message)
        self.assertIn("https://tracker.example/two", message)

    def test_empty_result_has_no_message(self):
        self.assertIsNone(MODULE.build_message(result([])))

    def test_message_omits_complete_lines_to_fit_limit(self):
        artifacts = [
            {"change": "updated", "path": f"docs/artifact/{number}-" + "x" * 200, "url": "https://tracker"}
            for number in range(30)
        ]
        message = MODULE.build_message(result(artifacts))
        self.assertLessEqual(len(message), MODULE.MAX_MESSAGE_LENGTH)
        self.assertIn("more artifact changes", message)
        self.assertIn("https://github.example/owner/repository/pull/21", message)

    def test_both_providers_send_the_same_text_payload(self):
        received = []

        class Handler(BaseHTTPRequestHandler):
            def do_POST(self):
                length = int(self.headers["Content-Length"])
                received.append(json.loads(self.rfile.read(length)))
                self.send_response(200)
                self.end_headers()

            def log_message(self, format, *args):
                return None

        server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        thread = threading.Thread(target=server.serve_forever)
        thread.start()
        try:
            webhook = f"http://127.0.0.1:{server.server_port}/webhook"
            for provider in ("google-chat", "slack"):
                MODULE.send_message(provider, webhook, "message")
        finally:
            server.shutdown()
            server.server_close()
            thread.join()
        self.assertEqual([{"text": "message"}, {"text": "message"}], received)

    def test_retryable_response_retries_then_succeeds(self):
        attempts = []
        delays = []

        def opener(request, timeout):
            attempts.append(request)
            if len(attempts) < 3:
                raise urllib.error.HTTPError(request.full_url, 503, "unavailable", {}, None)
            return Response()

        MODULE.send_message(
            "slack", "https://webhook.example/secret", "message", opener, delays.append
        )
        self.assertEqual(3, len(attempts))
        self.assertEqual([1, 2], delays)

    def test_non_retryable_response_fails_once(self):
        attempts = []

        def opener(request, timeout):
            attempts.append(request)
            raise urllib.error.HTTPError(request.full_url, 400, "bad request", {}, None)

        with self.assertRaisesRegex(RuntimeError, "HTTP 400"):
            MODULE.send_message("google-chat", "https://webhook.example/secret", "message", opener)
        self.assertEqual(1, len(attempts))

    def test_exhausted_network_retries_do_not_expose_webhook(self):
        delays = []

        def opener(request, timeout):
            raise urllib.error.URLError("offline")

        with self.assertRaisesRegex(RuntimeError, "network error") as raised:
            MODULE.send_message(
                "slack", "https://webhook.example/private", "message", opener, delays.append
            )
        self.assertNotIn("private", str(raised.exception))
        self.assertEqual([1, 2], delays)

    def test_missing_webhook_fails_for_nonempty_result(self):
        with self.assertRaisesRegex(RuntimeError, "must not be empty"):
            MODULE.send_message("slack", "", MODULE.build_message(result()))


if __name__ == "__main__":
    unittest.main()
