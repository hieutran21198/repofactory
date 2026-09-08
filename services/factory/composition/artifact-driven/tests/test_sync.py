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
        self.assertIn("repofactory:artifact:owner/repo:docs/artifact/feat-login/README.md", body)


class FakeAdapter:
    def __init__(self):
        self.upserts = []
        self.links = []
        self.existing = {}

    def lookup(self, path):
        return self.existing.get(path)

    def upsert(self, artifact, title, body, status, old_path="", withdrawn=False):
        self.upserts.append((artifact.path, status, old_path, withdrawn))
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
