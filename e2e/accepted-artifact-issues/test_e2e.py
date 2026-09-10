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

    def test_selects_setup_environment_for_github_projects(self):
        self.assertEqual(
            ["GH_TOKEN"],
            MODULE.setup_environment(["github-projects"]),
        )

    def test_selects_setup_environment_for_trello(self):
        self.assertEqual(
            ["GH_TOKEN", "TRELLO_API_KEY", "TRELLO_TOKEN"],
            MODULE.setup_environment(["trello"]),
        )

    def test_merges_setup_state_without_removing_other_provider(self):
        state = {
            "owner": MODULE.OWNER,
            "repositories": {"trello": {"default_branch": "main"}},
            "trello_board": {"id": "board", "url": "https://trello.example/board"},
        }
        repositories = {
            "github-projects": {
                "name": "repository",
                "html_url": "https://github.example/repository",
                "default_branch": "main",
            }
        }
        project = {
            "id": "project",
            "number": 7,
            "url": "https://github.example/project",
        }

        MODULE.merge_setup_state(state, repositories, project)

        self.assertIn("trello", state["repositories"])
        self.assertEqual("board", state["trello_board"]["id"])
        self.assertEqual("project", state["github_project"]["id"])

    def test_rejects_provider_without_setup_state(self):
        with self.assertRaisesRegex(MODULE.CheckError, "Run setup for trello"):
            MODULE.check_provider_state("trello", {"repositories": {}})

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
        self.assertEqual("Accepted", statuses[scenario.paths["change"]])
        self.assertEqual("# Change: Initial\n", files[scenario.paths["change"]])
        for key, path in scenario.paths.items():
            if key != "feature":
                self.assertIn("/changes/change-initial/", path, key)

    def test_classifies_trello_description_metadata(self):
        root = "docs/artifact/feat-a"
        self.assertEqual(
            ("feature-summary", None),
            MODULE.artifact_metadata(f"{root}/README.md"),
        )
        self.assertEqual(
            ("change-summary", f"{root}/README.md"),
            MODULE.artifact_metadata(f"{root}/changes/change-initial/README.md"),
        )
        self.assertEqual(
            ("requirement", f"{root}/changes/change-initial/requirements/README.md"),
            MODULE.artifact_metadata(
                f"{root}/changes/change-initial/requirements/req-a.md"
            ),
        )
        with self.assertRaises(MODULE.CheckError):
            MODULE.artifact_metadata(f"{root}/requirements/req-a.md")
        with self.assertRaises(MODULE.CheckError):
            MODULE.artifact_metadata(f"{root}/versions/1.0.0/requirements/req-a.md")

    def test_retries_a_provider_assertion(self):
        attempts = []

        def check():
            attempts.append(len(attempts) + 1)
            if len(attempts) < 3:
                raise MODULE.CheckError("not ready")
            return "ready"

        self.assertEqual("ready", MODULE.retry_check(check, timeout=1, delay=0))
        self.assertEqual([1, 2, 3], attempts)

    def test_runs_second_provider_after_first_provider_fails(self):
        attempts = []

        def check(provider):
            attempts.append(provider)
            if provider == "github-projects":
                raise MODULE.CheckError("status is not ready")
            return {"provider": provider, "status": "passed"}

        reports, errors = MODULE.collect_provider_reports(
            ["github-projects", "trello"], check
        )

        self.assertEqual(["github-projects", "trello"], attempts)
        self.assertEqual("failed", reports[0]["status"])
        self.assertEqual("passed", reports[1]["status"])
        self.assertEqual(["github-projects: status is not ready"], errors)


class FakeTrelloApi:
    def __init__(self):
        self.requests = []

    def request(self, method, path, data=None):
        self.requests.append((method, path, data))
        if path.startswith("/members/me/boards"):
            return [
                {
                    "id": "board",
                    "name": MODULE.RESOURCE_NAME,
                    "closed": False,
                    "url": "https://trello.example/board",
                    "prefs": {"permissionLevel": "private"},
                }
            ]
        if path == "/boards/board/lists?filter=all":
            return [
                {"id": status.lower(), "name": status, "closed": False}
                for status in MODULE.STATUSES
            ]
        raise AssertionError(f"Unexpected request: {method} {path}")


class TrelloSetupTest(unittest.TestCase):
    def test_reuses_board_without_custom_fields_requests(self):
        api = FakeTrelloApi()

        board = MODULE.ensure_trello_board(api)

        self.assertEqual("board", board["id"])
        paths = [path.lower() for _, path, _ in api.requests]
        self.assertFalse(any("customfield" in path for path in paths), paths)


class RendererTest(unittest.TestCase):
    def test_renders_github_projects_without_trello_state(self):
        files = MODULE.render_files(
            "github-projects",
            {"github_project": {"number": 7}},
        )
        config = json.loads(files[".github/artifact-issues/config.json"])
        self.assertEqual("github-projects", config["provider"])

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
                guide = files[
                    "docs/wiki/documentation/artifact-driven/project-issues.md"
                ]
                self.assertIn("Trello Free workspaces are supported", guide)
                self.assertIn("Custom Fields are not required", guide)

    def test_renders_optional_trello_implementation_board(self):
        files = MODULE.render_files("trello", {
            "trello_board": {"id": "planning"},
            "trello_implementation_board": {"id": "implementation"},
        })
        config = json.loads(files[".github/artifact-issues/config.json"])
        self.assertEqual("planning", config["trello"]["boardId"])
        self.assertEqual("implementation", config["trello"]["implementationBoardId"])

    def test_renders_a_valid_slack_notification_step(self):
        files = MODULE.render_files(
            "trello",
            {"trello_board": {"id": "board"}},
            notification_provider="slack",
            notification_secret="TEAM_SLACK_WEBHOOK",
        )

        self.assertIn(".github/artifact-issues/notify.py", files)
        self.assertIn(
            """          ARTIFACT_ISSUES_RESULT: ${{ runner.temp }}/accepted-artifacts.json

      - name: Notify the team about accepted artifacts
        if: github.event_name == 'pull_request_target'
        run: python3 .github/artifact-issues/notify.py
        env:
          ARTIFACT_ISSUES_RESULT: ${{ runner.temp }}/accepted-artifacts.json
          ARTIFACT_NOTIFICATION_USES: '["slack"]'
          ARTIFACT_NOTIFICATION_SLACK_WEBHOOK: ${{ secrets.TEAM_SLACK_WEBHOOK }}""",
            files[".github/workflows/accepted-artifact-issues.yml"],
        )


if __name__ == "__main__":
    unittest.main()
