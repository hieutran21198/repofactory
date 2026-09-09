import importlib.util
import json
import sys
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name("e2e.py")
SPEC = importlib.util.spec_from_file_location("accepted_artifact_issues_e2e", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class PureFunctionTest(unittest.TestCase):
    def test_selects_all_providers_in_stable_order(self):
        self.assertEqual(
            ["github-projects", "trello"],
            MODULE.selected_providers("all"),
        )

    def test_extracts_only_the_marker_for_the_repository(self):
        body = "<!-- repofactory:artifact:owner/repo:docs/artifact/feat-a/README.md -->"
        self.assertEqual(
            "docs/artifact/feat-a/README.md",
            MODULE.marker_path("owner/repo", body),
        )
        self.assertIsNone(MODULE.marker_path("owner/other", body))

    def test_fixture_has_the_expected_tree_and_statuses(self):
        state = {
            "repositories": {
                "github-projects": {
                    "default_branch": "main",
                }
            }
        }
        scenario = MODULE.new_scenario("github-projects", state)
        files = MODULE.artifact_files(scenario)
        statuses = MODULE.expected_statuses(scenario)
        self.assertEqual(set(files), set(statuses))
        self.assertEqual("Ready", statuses[scenario.paths["task"]])
        self.assertEqual("Accepted", statuses[scenario.paths["feature"]])


class RendererTest(unittest.TestCase):
    def test_renders_each_provider_from_the_factory_module(self):
        state = {
            "github_project": {"number": 7},
            "trello_board": {"id": "board"},
        }
        for provider in ("github-projects", "trello"):
            with self.subTest(provider=provider):
                files = MODULE.render_files(provider, state)
                self.assertEqual(
                    {
                        ".github/artifact-issues/config.json",
                        ".github/artifact-issues/sync.py",
                        ".github/workflows/accepted-artifact-issues.yml",
                        "docs/wiki/documentation/artifact-driven/project-issues.md",
                    },
                    set(files),
                )
                config = json.loads(files[".github/artifact-issues/config.json"])
                self.assertEqual(provider, config["provider"])


if __name__ == "__main__":
    unittest.main()
