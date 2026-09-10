import importlib.util
import os
import re
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

SCRIPT = Path(__file__).parents[1] / "_assets" / "project-issues" / "sync.py"
SPEC = importlib.util.spec_from_file_location("artifact_issue_sync", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)

INITIAL = "docs/artifact/feat-login/changes/change-initial"


class ArtifactClassificationTest(unittest.TestCase):
    def assert_artifact(self, path, kind, parent):
        artifact = MODULE.classify_artifact(path)
        self.assertIsNotNone(artifact)
        self.assertEqual(kind, artifact.kind)
        self.assertEqual(parent, artifact.parent)

    def test_feature_summary(self):
        self.assert_artifact(
            "docs/artifact/feat-login/README.md",
            "feature-summary",
            None,
        )

    def test_requirement_tree(self):
        self.assert_artifact(
            f"{INITIAL}/requirements/README.md",
            "master-requirement",
            f"{INITIAL}/README.md",
        )
        self.assert_artifact(
            f"{INITIAL}/requirements/req-password.md",
            "requirement",
            f"{INITIAL}/requirements/README.md",
        )

    def test_specification_and_task_tree(self):
        self.assert_artifact(
            f"{INITIAL}/specifications/spec-api.md",
            "specification",
            f"{INITIAL}/specifications/README.md",
        )

    def test_decision_uses_related_specification_as_parent(self):
        change = "docs/artifact/feat-accepted-artifact-issues/changes/change-initial"
        with mock.patch.object(MODULE, "related_specification", return_value="spec-sync-workflow"):
            self.assert_artifact(
                f"{change}/decisions/adr-accepted-only.md",
                "decision",
                f"{change}/specifications/spec-sync-workflow.md",
            )
        self.assert_artifact(
            f"{INITIAL}/tasks/task-api.md",
            "task",
            f"{INITIAL}/tasks/README.md",
        )

    def test_change_tree(self):
        self.assert_artifact(
            "docs/artifact/feat-login/changes/change-lockout/README.md",
            "change-summary",
            "docs/artifact/feat-login/README.md",
        )
        self.assert_artifact(
            "docs/artifact/feat-login/changes/change-lockout/requirements/README.md",
            "master-requirement",
            "docs/artifact/feat-login/changes/change-lockout/README.md",
        )
        self.assert_artifact(
            "docs/artifact/feat-login/changes/change-lockout/tasks/task-rule.md",
            "task",
            "docs/artifact/feat-login/changes/change-lockout/tasks/README.md",
        )

    def test_change_initial_is_an_ordinary_change(self):
        for change in (INITIAL, "docs/artifact/feat-login/changes/change-lockout"):
            self.assert_artifact(
                f"{change}/README.md",
                "change-summary",
                "docs/artifact/feat-login/README.md",
            )
            self.assert_artifact(
                f"{change}/specifications/README.md",
                "master-specification",
                f"{change}/README.md",
            )
            self.assert_artifact(
                f"{change}/specifications/spec-api.md",
                "specification",
                f"{change}/specifications/README.md",
            )
            self.assert_artifact(
                f"{change}/tasks/README.md",
                "implementation-plan",
                f"{change}/README.md",
            )

    def test_global_index_and_code_are_not_artifacts(self):
        self.assertIsNone(MODULE.classify_artifact("docs/artifact/README.md"))
        self.assertIsNone(MODULE.classify_artifact("services/login/default.nix"))
        self.assertTrue(MODULE.is_feature_markdown("docs/artifact/feat-login/notes.md"))

    def test_body_has_stable_and_immutable_links(self):
        artifact = MODULE.classify_artifact("docs/artifact/feat-login/README.md")
        body = MODULE.artifact_body(
            artifact,
            "owner/repo",
            "https://github.com",
            "main",
            "1234567890abcdef",
            "https://github.com/owner/repo/pull/7",
        )
        self.assertIn("blob/main/docs/artifact/feat-login/README.md", body)
        self.assertIn("blob/1234567890abcdef/docs/artifact/feat-login/README.md", body)
        self.assertIn("Artifact type: `feature-summary`", body)
        self.assertIn("repofactory:artifact:owner/repo:docs/artifact/feat-login/README.md", body)

    def test_body_has_parent_path_and_link(self):
        artifact = MODULE.classify_artifact(f"{INITIAL}/requirements/req-password.md")
        body = MODULE.artifact_body(
            artifact,
            "owner/repo",
            "https://github.com",
            "main",
            "1234567890abcdef",
            "https://github.com/owner/repo/pull/7",
            "https://trello.com/c/parent",
        )
        self.assertIn(
            f"Parent artifact: [`{INITIAL}/requirements/README.md`]"
            "(https://trello.com/c/parent)",
            body,
        )


class QueueApi:
    def __init__(self, responses):
        self.responses = list(responses)
        self.requests = []

    def request(self, method, url, token="", data=None, headers=None):
        self.requests.append((method, url, data))
        if not self.responses:
            raise AssertionError(f"Unexpected request: {method} {url}")
        return self.responses.pop(0)


class GitHubAdapterTest(unittest.TestCase):
    def test_upsert_replaces_managed_label_and_preserves_user_label(self):
        path = f"{INITIAL}/requirements/req-password.md"
        artifact = MODULE.classify_artifact(path)
        updated = {
            "id": 7,
            "number": 3,
            "node_id": "node",
            "html_url": "https://github.example/issues/3",
            "body": "body",
            "state": "open",
            "labels": [{"name": "user-label"}, {"name": "artifact:requirement"}],
        }
        api = QueueApi([updated])
        adapter = MODULE.GitHubAdapter(
            {"ownership": "personal", "owner": "owner", "projectNumber": 1},
            "owner/repo",
            api,
        )
        adapter.issues[path] = {
            **updated,
            "labels": [{"name": "user-label"}, {"name": "artifact:task"}],
        }

        adapter.upsert(artifact, "Password", "body", "Accepted")

        method, url, payload = api.requests[0]
        self.assertEqual("PATCH", method)
        self.assertIn("/repos/owner/repo/issues/3", url)
        self.assertEqual(["user-label", "artifact:requirement"], payload["labels"])

    def test_link_sends_replace_parent(self):
        api = QueueApi([[], None])
        adapter = MODULE.GitHubAdapter(
            {"ownership": "personal", "owner": "owner", "projectNumber": 1},
            "owner/repo",
            api,
        )
        parent = MODULE.IssueRef(3, "https://github.example/owner/repo/issues/3", False)
        child = MODULE.IssueRef(7, "https://github.example/owner/repo/issues/7", True)

        adapter.link(parent, child)

        method, url, payload = api.requests[1]
        self.assertEqual("POST", method)
        self.assertTrue(url.endswith("/repos/owner/repo/issues/3/sub_issues"))
        self.assertEqual({"sub_issue_id": 7, "replace_parent": True}, payload)


class TrelloAdapterTest(unittest.TestCase):
    def setUp(self):
        self.old_key = os.environ.get("TRELLO_API_KEY")
        self.old_token = os.environ.get("TRELLO_TOKEN")
        os.environ["TRELLO_API_KEY"] = "key"
        os.environ["TRELLO_TOKEN"] = "token"
        self.statuses = {"feature-summary": "Accepted", "withdrawn": "Withdrawn"}

    def labels(self):
        return [
            {"id": f"label-{kind}", "name": MODULE.type_label(kind), "color": color}
            for kind, color in MODULE.TRELLO_LABEL_COLORS.items()
        ]

    def tearDown(self):
        for name, value in (
            ("TRELLO_API_KEY", self.old_key),
            ("TRELLO_TOKEN", self.old_token),
        ):
            if value is None:
                os.environ.pop(name, None)
            else:
                os.environ[name] = value

    def assert_no_custom_fields_request(self, api):
        urls = [url.lower() for _, url, _ in api.requests]
        self.assertFalse(any("customfield" in url for url in urls), urls)

    def test_preflight_uses_lists_and_description_markers_only(self):
        path = "docs/artifact/feat-login/README.md"
        marker = MODULE.artifact_marker("owner/repo", path)
        other_marker = MODULE.artifact_marker("other/repo", "docs/artifact/feat-other/README.md")
        api = QueueApi(
            [
                {"id": "board-id"},
                [
                    {"id": "accepted", "name": "Accepted", "closed": False},
                    {"id": "withdrawn", "name": "Withdrawn", "closed": False},
                ],
                self.labels(),
                [
                    {"id": "card", "desc": marker, "url": "https://trello/card", "closed": False},
                    {"id": "other", "desc": other_marker, "url": "https://trello/other", "closed": False},
                ],
            ]
        )
        adapter = MODULE.TrelloAdapter({"boardId": "board"}, "owner/repo", api)

        adapter.preflight(self.statuses)

        self.assertEqual("card", adapter.cards[path]["id"])
        self.assertEqual(1, len(adapter.cards))
        self.assert_no_custom_fields_request(api)

    def test_upsert_writes_description_without_custom_fields(self):
        path = "docs/artifact/feat-login/README.md"
        artifact = MODULE.classify_artifact(path)
        body = MODULE.artifact_body(
            artifact,
            "owner/repo",
            "https://github.com",
            "main",
            "1234567890abcdef",
            "https://github.com/owner/repo/pull/7",
        )
        api = QueueApi(
            [
                {"id": "board-id"},
                [
                    {"id": "accepted", "name": "Accepted", "closed": False},
                    {"id": "withdrawn", "name": "Withdrawn", "closed": False},
                ],
                self.labels(),
                [],
                {
                    "id": "card",
                    "desc": body,
                    "url": "https://trello/card-title",
                    "shortUrl": "https://trello/c/card",
                    "closed": False,
                    "idLabels": ["user-label"],
                },
                None,
            ]
        )
        adapter = MODULE.TrelloAdapter({"boardId": "board"}, "owner/repo", api)
        adapter.preflight(self.statuses)

        ref = adapter.upsert(artifact, "Feature: Login", body, "Accepted")

        self.assertEqual("card", ref.id)
        self.assertEqual("https://trello/c/card", ref.url)
        method, url, payload = next(
            request for request in api.requests if request[0] == "POST" and "/cards?" in request[1]
        )
        self.assertEqual("POST", method)
        self.assertIn("/cards?", url)
        self.assertEqual(body, payload["desc"])
        self.assertEqual("accepted", payload["idList"])
        self.assertEqual("POST", api.requests[-1][0])
        self.assertIn("/cards/card/idLabels?", api.requests[-1][1])
        self.assertEqual("label-feature-summary", api.requests[-1][2]["value"])
        self.assertEqual(
            ["label-feature-summary", "user-label"],
            adapter.cards[path]["idLabels"],
        )
        self.assert_no_custom_fields_request(api)

    def test_preflight_uses_resolved_board_id_for_new_labels(self):
        responses = [
            {"id": "internal-board-id"},
            [
                {"id": "accepted", "name": "Accepted", "closed": False},
                {"id": "withdrawn", "name": "Withdrawn", "closed": False},
            ],
            [],
        ] + [
            {"id": f"label-{kind}", "name": MODULE.type_label(kind)} for kind in MODULE.ARTIFACT_KINDS
        ] + [[]]
        api = QueueApi(responses)
        adapter = MODULE.TrelloAdapter({"boardId": "CaFqAJ3t"}, "owner/repo", api)

        adapter.preflight(self.statuses)

        label_requests = [request for request in api.requests if request[0] == "POST" and "/labels?" in request[1]]
        self.assertEqual(len(MODULE.ARTIFACT_KINDS), len(label_requests))
        self.assertTrue(all(payload["idBoard"] == "internal-board-id" for _, _, payload in label_requests))

    def test_label_merge_preserves_user_labels(self):
        issue = {"labels": [{"name": "user-label"}, {"name": "artifact:task"}]}
        self.assertEqual(
            ["user-label", "artifact:requirement"],
            MODULE.issue_label_names(issue, "requirement"),
        )

    def test_label_model_covers_all_artifact_kinds(self):
        self.assertEqual(set(MODULE.ARTIFACT_KINDS), set(MODULE.GITHUB_LABEL_COLORS))
        self.assertEqual(set(MODULE.ARTIFACT_KINDS), set(MODULE.TRELLO_LABEL_COLORS))

    def test_split_board_routes_only_plans_and_tasks(self):
        adapter = MODULE.TrelloAdapter(
            {"boardId": "planning", "implementationBoardId": "implementation"},
            "owner/repo",
            QueueApi([]),
        )
        self.assertEqual("implementation", adapter.board_for("task"))
        self.assertEqual("implementation", adapter.board_for("implementation-plan"))
        self.assertEqual("planning", adapter.board_for("requirement"))
        self.assertEqual("planning", adapter.board_for("change-summary"))

    def test_upsert_moves_existing_task_and_keeps_identity(self):
        path = f"{INITIAL}/tasks/task-api.md"
        artifact = MODULE.classify_artifact(path)
        moved = {
            "id": "card",
            "idBoard": "implementation",
            "idLabels": ["old-task", "user-label"],
            "url": "https://trello/card",
            "shortUrl": "https://trello/c/card",
            "desc": "body",
            "closed": False,
        }
        api = QueueApi([moved, None, None])
        adapter = MODULE.TrelloAdapter(
            {"boardId": "planning", "implementationBoardId": "implementation"},
            "owner/repo",
            api,
        )
        adapter.boards = {
            "planning": {"lists": {"Ready": "planning-ready"}, "labels": {"artifact:task": {"id": "old-task"}}},
            "implementation": {"lists": {"Ready": "implementation-ready"}, "labels": {"artifact:task": {"id": "new-task"}}},
        }
        adapter.cards[path] = {**moved, "idBoard": "planning"}

        ref = adapter.upsert(artifact, "Task", "body", "Ready")

        self.assertEqual("card", ref.id)
        payload = api.requests[0][2]
        self.assertEqual("implementation", payload["idBoard"])
        self.assertEqual("implementation-ready", payload["idList"])
        self.assertEqual(["new-task", "user-label"], adapter.cards[path]["idLabels"])


class FakeAdapter:
    def __init__(self):
        self.upserts = []
        self.links = []
        self.existing = {}
        self.preflights = 0

    def preflight(self, statuses):
        self.preflights += 1

    def lookup(self, path):
        return self.existing.get(path)

    def upsert(self, artifact, title, body, status, old_path="", withdrawn=False):
        self.upserts.append((artifact.path, status, old_path, withdrawn, body))
        return MODULE.IssueRef(artifact.path, f"https://tracker/{artifact.path}", True, body)

    def link(self, parent, child):
        self.links.append((parent.id, child.id))


class SynchronizerTest(unittest.TestCase):
    def setUp(self):
        self.old_repository = os.environ.get("GITHUB_REPOSITORY")
        self.old_result = os.environ.get("ARTIFACT_ISSUES_RESULT")
        os.environ["GITHUB_REPOSITORY"] = "owner/repo"
        self.statuses = {
            "feature-summary": "Accepted",
            "master-requirement": "Accepted",
            "requirement": "Accepted",
            "master-specification": "Accepted",
            "specification": "Accepted",
            "decision": "Accepted",
            "implementation-plan": "Accepted",
            "task": "Ready",
            "change-summary": "Accepted",
            "withdrawn": "Withdrawn",
        }

    def tearDown(self):
        if self.old_repository is None:
            os.environ.pop("GITHUB_REPOSITORY", None)
        else:
            os.environ["GITHUB_REPOSITORY"] = self.old_repository
        if self.old_result is None:
            os.environ.pop("ARTIFACT_ISSUES_RESULT", None)
        else:
            os.environ["ARTIFACT_ISSUES_RESULT"] = self.old_result

    def make_sync(self, adapter, event=None):
        return MODULE.Synchronizer(
            {"provider": "fake", "statuses": self.statuses},
            event or {"repository": {"default_branch": "main"}},
            adapter=adapter,
        )

    def run_changes(self, changes):
        """Run the synchronizer on a fixed list of changed files and return the adapter and result."""
        adapter = FakeAdapter()

        class TestSynchronizer(MODULE.Synchronizer):
            def changed_files(self):
                return changes

        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            os.environ["ARTIFACT_ISSUES_RESULT"] = str(output)
            sync = TestSynchronizer(
                {"provider": "fake", "statuses": self.statuses},
                {"repository": {"default_branch": "main"}},
                adapter=adapter,
            )
            sync.run()
            result = MODULE.json.loads(output.read_text())
        return adapter, result

    def run_manual_scan(self, files):
        """Run the manual full scan on a temporary tree that holds the given files."""
        adapter = FakeAdapter()
        cwd = os.getcwd()
        with tempfile.TemporaryDirectory() as directory:
            for path in files:
                target = Path(directory) / path
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text("# Title\n")
            output = Path(directory) / "result.json"
            os.environ["ARTIFACT_ISSUES_RESULT"] = str(output)
            os.chdir(directory)
            try:
                self.make_sync(adapter).run()
            finally:
                os.chdir(cwd)
            result = MODULE.json.loads(output.read_text())
        return adapter, result

    def test_sync_builds_parent_chain_before_leaf(self):
        adapter = FakeAdapter()
        sync = self.make_sync(adapter)
        change = "docs/artifact/feat-accepted-artifact-issues/changes/change-initial"
        leaf = f"{change}/requirements/req-accepted-only.md"
        sync.sync_path(leaf)
        self.assertEqual(
            [
                "docs/artifact/feat-accepted-artifact-issues/README.md",
                f"{change}/README.md",
                f"{change}/requirements/README.md",
                leaf,
            ],
            [item[0] for item in adapter.upserts],
        )
        self.assertEqual(3, len(adapter.links))

    def test_withdraw_uses_configured_status(self):
        adapter = FakeAdapter()
        sync = self.make_sync(adapter)
        sync.withdraw_path(f"{INITIAL}/tasks/task-api.md")
        self.assertEqual("Withdrawn", adapter.upserts[0][1])
        self.assertTrue(adapter.upserts[0][3])

    def test_withdraw_keeps_parent_description_metadata(self):
        adapter = FakeAdapter()
        parent = f"{INITIAL}/tasks/README.md"
        adapter.existing[parent] = MODULE.IssueRef(
            "parent", "https://trello.example/parent", False
        )
        sync = self.make_sync(adapter)

        sync.withdraw_path(f"{INITIAL}/tasks/task-api.md")

        self.assertIn(
            f"Parent artifact: [`{parent}`](https://trello.example/parent)",
            adapter.upserts[0][4],
        )

    def test_unchanged_parent_is_not_updated(self):
        adapter = FakeAdapter()
        change = "docs/artifact/feat-accepted-artifact-issues/changes/change-initial"
        feature = "docs/artifact/feat-accepted-artifact-issues/README.md"
        summary = f"{change}/README.md"
        master = f"{change}/requirements/README.md"
        adapter.existing[feature] = MODULE.IssueRef("feature", "https://tracker/feature", False)
        adapter.existing[summary] = MODULE.IssueRef("summary", "https://tracker/summary", False)
        adapter.existing[master] = MODULE.IssueRef("master", "https://tracker/master", False)
        sync = self.make_sync(adapter)
        leaf = f"{change}/requirements/req-accepted-only.md"
        sync.sync_path(leaf)
        self.assertEqual([leaf], [item[0] for item in adapter.upserts])

    def test_run_writes_changed_artifacts_without_implicit_parents(self):
        class TestSynchronizer(MODULE.Synchronizer):
            def changed_files(self):
                return [
                    {"filename": "docs/artifact/feat-added/README.md", "status": "added"},
                    {
                        "filename": "docs/artifact/feat-updated/changes/change-initial/requirements/README.md",
                        "status": "modified",
                    },
                    {
                        "filename": "docs/artifact/feat-renamed/changes/change-initial/tasks/README.md",
                        "previous_filename": "docs/artifact/feat-old/changes/change-initial/tasks/README.md",
                        "status": "renamed",
                    },
                    {
                        "filename": "docs/artifact/feat-removed/changes/change-initial/tasks/task-old.md",
                        "status": "removed",
                    },
                ]

            def comment_on_pull_request(self):
                return None

        event = {
            "repository": {"default_branch": "main"},
            "pull_request": {
                "number": 21,
                "title": "Accept artifacts",
                "html_url": "https://github.example/pull/21",
                "merge_commit_sha": "abc123",
            },
        }
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            os.environ["ARTIFACT_ISSUES_RESULT"] = str(output)
            sync = TestSynchronizer(
                {"provider": "fake", "statuses": self.statuses}, event, adapter=FakeAdapter()
            )

            sync.run()

            result = MODULE.json.loads(output.read_text())
        self.assertEqual("owner/repo", result["repository"])
        self.assertEqual(21, result["pullRequest"]["number"])
        self.assertEqual(
            ["added", "withdrawn", "renamed", "updated"],
            [item["change"] for item in result["artifacts"]],
        )
        self.assertEqual(4, len(result["artifacts"]))
        renamed = next(item for item in result["artifacts"] if item["change"] == "renamed")
        self.assertEqual(
            "docs/artifact/feat-old/changes/change-initial/tasks/README.md",
            renamed["previousPath"],
        )

    def test_run_writes_empty_result_without_provider_preflight(self):
        class TestSynchronizer(MODULE.Synchronizer):
            def changed_files(self):
                return [{"filename": "README.md", "status": "modified"}]

        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            os.environ["ARTIFACT_ISSUES_RESULT"] = str(output)
            sync = TestSynchronizer(
                {"provider": "fake", "statuses": self.statuses},
                {"repository": {"default_branch": "main"}},
                adapter=FakeAdapter(),
            )

            sync.run()

            result = MODULE.json.loads(output.read_text())
        self.assertEqual([], result["artifacts"])

    def test_root_level_folders_are_unsupported(self):
        for legacy in (
            "docs/artifact/feat-login/requirements/README.md",
            "docs/artifact/feat-login/requirements/req-password.md",
            "docs/artifact/feat-login/specifications/spec-api.md",
            "docs/artifact/feat-login/decisions/adr-choice.md",
            "docs/artifact/feat-login/tasks/README.md",
            "docs/artifact/feat-login/tasks/task-api.md",
        ):
            self.assertTrue(MODULE.is_feature_markdown(legacy), legacy)
            self.assertIsNone(MODULE.classify_artifact(legacy), legacy)
        path = "docs/artifact/feat-login/requirements/req-password.md"
        with self.assertRaisesRegex(RuntimeError, "Unsupported feature artifact paths: .*" + re.escape(path)):
            self.run_changes([{"filename": path, "status": "modified"}])

    def test_versions_are_ignored_in_pull_request(self):
        paths = [
            "docs/artifact/feat-login/versions/1.0.0/requirements/README.md",
            "docs/artifact/feat-login/versions/1.0.0/specifications/spec-api.md",
            "docs/artifact/feat-login/versions/1.0.0/decisions/adr-choice.md",
        ]
        for path in paths:
            self.assertFalse(MODULE.is_feature_markdown(path), path)
            self.assertIsNone(MODULE.classify_artifact(path), path)

        adapter, result = self.run_changes([{"filename": path, "status": "added"} for path in paths])

        self.assertEqual([], result["artifacts"])
        self.assertEqual([], adapter.upserts)
        self.assertEqual(0, adapter.preflights)

    def test_versions_are_ignored_in_manual_scan(self):
        adapter, result = self.run_manual_scan(
            [
                "docs/artifact/feat-login/versions/1.0.0/requirements/README.md",
                "docs/artifact/feat-login/versions/1.0.0/requirements/req-password.md",
            ]
        )
        self.assertEqual([], result["artifacts"])
        self.assertEqual([], adapter.upserts)
        self.assertEqual(0, adapter.preflights)

    def test_unmigrated_tree_fails_manual_scan(self):
        path = "docs/artifact/feat-login/requirements/README.md"
        with self.assertRaisesRegex(RuntimeError, "Unsupported feature artifact paths: .*" + re.escape(path)):
            self.run_manual_scan(["docs/artifact/feat-login/README.md", path])

    def test_rename_from_root_path_keeps_identity(self):
        legacy = "docs/artifact/feat-login/tasks/task-api.md"
        current = f"{INITIAL}/tasks/task-api.md"

        adapter, result = self.run_changes(
            [{"filename": current, "previous_filename": legacy, "status": "renamed"}]
        )

        self.assertIn((current, "Ready", legacy, False), [item[:4] for item in adapter.upserts])
        renamed = next(item for item in result["artifacts"] if item["change"] == "renamed")
        self.assertEqual(current, renamed["path"])
        self.assertEqual(legacy, renamed["previousPath"])

    def test_removed_root_path_is_ignored(self):
        adapter, result = self.run_changes(
            [{"filename": "docs/artifact/feat-login/tasks/task-api.md", "status": "removed"}]
        )
        self.assertEqual([], adapter.upserts)
        self.assertEqual([], result["artifacts"])

    def test_unsupported_change_path_fails(self):
        path = "docs/artifact/feat-login/changes/change-x/notes.md"
        with self.assertRaisesRegex(RuntimeError, "Unsupported feature artifact paths: .*" + re.escape(path)):
            self.run_changes([{"filename": path, "status": "added"}])


if __name__ == "__main__":
    unittest.main()
