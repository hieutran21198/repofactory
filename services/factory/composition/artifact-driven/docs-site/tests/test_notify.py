import importlib.util
import json
import sys
import threading
import unittest
import urllib.error
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "_assets" / ".github" / "docs-site" / "notify.py"
SPEC = importlib.util.spec_from_file_location("docs_site_notify", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


def environment():
    return {
        "DOCS_SITE_REPOSITORY": "owner/repository",
        "DOCS_SITE_DEPLOYMENT_URL": "https://owner.github.io/repository/",
        "DOCS_SITE_REF_NAME": "main",
        "DOCS_SITE_COMMIT_SHA": "0123456789abcdef",
        "DOCS_SITE_RUN_URL": "https://github.example/owner/repository/actions/runs/123",
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
    def test_build_message_has_deployment_context(self):
        message = MODULE.build_message(environment())
        self.assertIn("Documentation site deployed: owner/repository", message)
        self.assertIn("URL: https://owner.github.io/repository/", message)
        self.assertIn("Source: main @ 0123456", message)
        self.assertIn(
            "https://github.example/owner/repository/actions/runs/123", message
        )

    def test_build_message_checks_required_values(self):
        values = environment()
        values["DOCS_SITE_DEPLOYMENT_URL"] = ""
        with self.assertRaisesRegex(RuntimeError, "DOCS_SITE_DEPLOYMENT_URL"):
            MODULE.build_message(values)

    def test_build_message_checks_size_limit(self):
        values = environment()
        values["DOCS_SITE_REPOSITORY"] = "x" * MODULE.MAX_MESSAGE_LENGTH
        with self.assertRaisesRegex(RuntimeError, "size limit"):
            MODULE.build_message(values)

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

    def test_retryable_responses_retry_then_succeed(self):
        for status in (429, 503):
            with self.subTest(status=status):
                attempts = []
                delays = []

                def opener(request, timeout, attempts=attempts, status=status):
                    attempts.append(request)
                    if len(attempts) < 3:
                        raise urllib.error.HTTPError(
                            request.full_url, status, "unavailable", {}, None
                        )
                    return Response()

                MODULE.send_message(
                    "slack",
                    "https://webhook.example/secret",
                    "message",
                    opener=opener,
                    sleeper=delays.append,
                )
                self.assertEqual(3, len(attempts))
                self.assertEqual([1, 2], delays)

    def test_non_retryable_response_fails_once(self):
        attempts = []

        def opener(request, timeout):
            attempts.append(request)
            raise urllib.error.HTTPError(request.full_url, 400, "bad request", {}, None)

        with self.assertRaisesRegex(RuntimeError, "HTTP 400"):
            MODULE.send_message(
                "google-chat", "https://webhook.example/secret", "message", opener=opener
            )
        self.assertEqual(1, len(attempts))

    def test_exhausted_network_retries_do_not_expose_webhook(self):
        delays = []

        def opener(request, timeout):
            raise urllib.error.URLError("offline")

        with self.assertRaisesRegex(RuntimeError, "network error") as raised:
            MODULE.send_message(
                "slack",
                "https://webhook.example/private",
                "message",
                opener=opener,
                sleeper=delays.append,
            )
        self.assertNotIn("private", str(raised.exception))
        self.assertEqual([1, 2], delays)

    def test_missing_webhook_fails(self):
        with self.assertRaisesRegex(RuntimeError, "must not be empty"):
            MODULE.send_message("slack", "", "message")

    def test_unsupported_provider_fails(self):
        with self.assertRaisesRegex(RuntimeError, "Unsupported"):
            MODULE.send_message("email", "https://webhook.example/secret", "message")

    def test_telegram_uses_the_bot_api(self):
        requests = []

        def opener(request, timeout):
            requests.append(request)
            return Response()

        MODULE.send_message("telegram", "token", "message", "chat", opener)
        self.assertEqual("https://api.telegram.org/bottoken/sendMessage", requests[0].full_url)
        self.assertEqual({"chat_id": "chat", "text": "message"}, json.loads(requests[0].data))

    def test_send_all_attempts_every_provider_before_it_fails(self):
        sent = []
        original = MODULE.send_message

        def deliver(provider, *args, **kwargs):
            sent.append(provider)
            if provider == "slack":
                raise RuntimeError("slack failed")

        MODULE.send_message = deliver
        try:
            with self.assertRaisesRegex(RuntimeError, "slack"):
                MODULE.send_all({
                    "DOCS_SITE_NOTIFICATION_USES": '["google-chat", "slack", "telegram"]',
                    "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK": "google",
                    "DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK": "slack",
                    "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN": "token",
                    "DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID": "chat",
                }, "message")
        finally:
            MODULE.send_message = original
        self.assertEqual(["google-chat", "slack", "telegram"], sent)


if __name__ == "__main__":
    unittest.main()
