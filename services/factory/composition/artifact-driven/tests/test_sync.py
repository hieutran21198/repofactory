import importlib.util
import os
import sys
import unittest
from pathlib import Path

SCRIPT = Path(__file__).parents[1] / "_assets" / "project-issues" / "sync.py"
SPEC = importlib.util.spec_from_file_location("artifact_issue_sync", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


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
            "docs/artifact/feat-login/requirements/README.md",
            "master-requirement",
            "docs/artifact/feat-login/README.md",
        )
        self.assert_artifact(
            "docs/artifact/feat-login/requirements/req-password.md",
            "requirement",
            "docs/artifact/feat-login/requirements/README.md",
        )

    def test_specification_and_task_tree(self):
        self.assert_artifact(
            "docs/artifact/feat-login/specifications/spec-api.md",
            "specification",
            "docs/artifact/feat-login/specifications/README.md",
        )

    def test_decision_uses_related_specification_as_parent(self):
        path = "docs/artifact/feat-accepted-artifact-issues/decisions/adr-accepted-only.md"
        self.assert_artifact(
            path,
            "decision",
            "docs/artifact/feat-accepted-artifact-issues/specifications/spec-sync-workflow.md",
        )
        self.assert_artifact(
            "docs/artifact/feat-login/tasks/task-api.md",
            "task",
            "docs/artifact/feat-login/tasks/README.md",
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
        artifact = MODULE.classify_artifact(
            "docs/artifact/feat-login/requirements/req-password.md"
        )
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
            "Parent artifact: [`docs/artifact/feat-login/requirements/README.md`]"
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
        path = "docs/artifact/feat-login/requirements/req-password.md"
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
        path = "docs/artifact/feat-login/tasks/task-api.md"
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

    def test_sync_builds_parent_chain_before_leaf(self):
        adapter = FakeAdapter()
        sync = MODULE.Synchronizer(
            {"provider": "fake", "statuses": self.statuses},
            {"repository": {"default_branch": "main"}},
            adapter=adapter,
        )
        leaf = "docs/artifact/feat-accepted-artifact-issues/requirements/req-accepted-only.md"
        sync.sync_path(leaf)
        self.assertEqual(
            [
                "docs/artifact/feat-accepted-artifact-issues/README.md",
                "docs/artifact/feat-accepted-artifact-issues/requirements/README.md",
                leaf,
            ],
            [item[0] for item in adapter.upserts],
        )
        self.assertEqual(2, len(adapter.links))

    def test_withdraw_uses_configured_status(self):
        adapter = FakeAdapter()
        sync = MODULE.Synchronizer(
            {"provider": "fake", "statuses": self.statuses},
            {"repository": {"default_branch": "main"}},
            adapter=adapter,
        )
        sync.withdraw_path("docs/artifact/feat-login/tasks/task-api.md")
        self.assertEqual("Withdrawn", adapter.upserts[0][1])
        self.assertTrue(adapter.upserts[0][3])

    def test_withdraw_keeps_parent_description_metadata(self):
        adapter = FakeAdapter()
        parent = "docs/artifact/feat-login/tasks/README.md"
        adapter.existing[parent] = MODULE.IssueRef(
            "parent", "https://trello.example/parent", False
        )
        sync = MODULE.Synchronizer(
            {"provider": "fake", "statuses": self.statuses},
            {"repository": {"default_branch": "main"}},
            adapter=adapter,
        )

        sync.withdraw_path("docs/artifact/feat-login/tasks/task-api.md")

        self.assertIn(
            f"Parent artifact: [`{parent}`](https://trello.example/parent)",
            adapter.upserts[0][4],
        )

    def test_unchanged_parent_is_not_updated(self):
        adapter = FakeAdapter()
        feature = "docs/artifact/feat-accepted-artifact-issues/README.md"
        master = "docs/artifact/feat-accepted-artifact-issues/requirements/README.md"
        adapter.existing[feature] = MODULE.IssueRef("feature", "https://tracker/feature", False)
        adapter.existing[master] = MODULE.IssueRef("master", "https://tracker/master", False)
        sync = MODULE.Synchronizer(
            {"provider": "fake", "statuses": self.statuses},
            {"repository": {"default_branch": "main"}},
            adapter=adapter,
        )
        leaf = "docs/artifact/feat-accepted-artifact-issues/requirements/req-accepted-only.md"
        sync.sync_path(leaf)
        self.assertEqual([leaf], [item[0] for item in adapter.upserts])


if __name__ == "__main__":
    unittest.main()
