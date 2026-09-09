#!/usr/bin/env python3
"""Run live checks for the accepted artifact issue integrations."""

from __future__ import annotations

import argparse
import base64
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any, Callable


OWNER = "hieutran21198"
REPOSITORIES = {
    "github-projects": "repofactory-e2e-github-projects",
    "trello": "repofactory-e2e-trello",
}
RESOURCE_NAME = "Repofactory E2E – Accepted Artifacts"
STATUSES = ("Accepted", "Ready", "Withdrawn")
MANAGED_COMMENT = "<!-- repofactory:accepted-artifact-issues -->"
LABEL_PREFIX = "artifact:"
WORKFLOW = "accepted-artifact-issues.yml"
SCRIPT_DIR = Path(__file__).resolve().parent
ROOT = SCRIPT_DIR.parents[1]
STATE_PATH = SCRIPT_DIR / ".state.json"
RESULTS_DIR = SCRIPT_DIR / "results"
WORKFLOW_TIMEOUT = 600


class CheckError(RuntimeError):
    """A live check failed."""


def log(message: str) -> None:
    print(message, flush=True)


def need_environment(names: list[str]) -> None:
    missing = [name for name in names if not os.environ.get(name)]
    if missing:
        raise CheckError("Set these environment variables: " + ", ".join(missing))


def run_command(args: list[str], *, stdin: str | None = None) -> str:
    result = subprocess.run(
        args,
        input=stdin,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
        cwd=ROOT,
    )
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise CheckError(f"Command failed: {args[0]}: {detail}")
    return result.stdout


def gh_api(method: str, path: str, data: dict[str, Any] | None = None) -> Any:
    args = ["gh", "api", path, "--method", method]
    stdin = None
    if data is not None:
        args.extend(["--input", "-"])
        stdin = json.dumps(data)
    output = run_command(args, stdin=stdin)
    if not output.strip():
        return None
    return json.loads(output)


def graphql(query: str, variables: dict[str, Any]) -> dict[str, Any]:
    result = gh_api("POST", "graphql", {"query": query, "variables": variables})
    if result.get("errors"):
        raise CheckError("GitHub GraphQL failed: " + json.dumps(result["errors"]))
    return result["data"]


class TrelloApi:
    def __init__(self) -> None:
        self.key = os.environ["TRELLO_API_KEY"]
        self.token = os.environ["TRELLO_TOKEN"]

    def request(
        self, method: str, path: str, data: dict[str, Any] | None = None
    ) -> Any:
        separator = "&" if "?" in path else "?"
        query = urllib.parse.urlencode({"key": self.key, "token": self.token})
        url = f"https://api.trello.com/1{path}{separator}{query}"
        body = json.dumps(data).encode() if data is not None else None
        headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "User-Agent": "repofactory-e2e",
        }
        request = urllib.request.Request(url, data=body, headers=headers, method=method)
        try:
            with urllib.request.urlopen(request) as response:
                content = response.read()
        except urllib.error.HTTPError as error:
            detail = error.read().decode(errors="replace")
            raise CheckError(f"Trello {method} {path} failed with HTTP {error.code}: {detail}")
        return json.loads(content) if content else None


def load_state() -> dict[str, Any]:
    if not STATE_PATH.exists():
        raise CheckError("Run setup before this command")
    return json.loads(STATE_PATH.read_text())


def load_setup_state() -> dict[str, Any]:
    if not STATE_PATH.exists():
        return {"owner": OWNER, "repositories": {}}
    state = load_state()
    if state.get("owner") != OWNER:
        raise CheckError(f"The state file must use the GitHub account {OWNER}")
    state.setdefault("repositories", {})
    return state


def save_state(state: dict[str, Any]) -> None:
    STATE_PATH.write_text(json.dumps(state, indent=2, sort_keys=True) + "\n")


def repository_path(provider: str) -> str:
    return f"{OWNER}/{REPOSITORIES[provider]}"


def ensure_github_account() -> None:
    login = gh_api("GET", "user")["login"]
    if login != OWNER:
        raise CheckError(f"GH_TOKEN belongs to {login}. It must belong to {OWNER}")


def ensure_repository(name: str) -> dict[str, Any]:
    path = f"repos/{OWNER}/{name}"
    try:
        repository = gh_api("GET", path)
    except CheckError as error:
        if "HTTP 404" not in str(error):
            raise
        repository = gh_api(
            "POST",
            "user/repos",
            {
                "name": name,
                "private": True,
                "auto_init": True,
                "description": "Repofactory accepted artifact issue E2E sandbox",
            },
        )
        log(f"Created {repository['html_url']}")
    if repository["owner"]["login"] != OWNER:
        raise CheckError(f"Repository {name} has an unexpected owner")
    if not repository["private"]:
        raise CheckError(f"Repository {name} must be private")
    return repository


PROJECT_QUERY = """
query($login:String!) {
  user(login:$login) {
    id
    projectsV2(first:100) { nodes { id number title closed public url fields(first:100) { nodes {
      ... on ProjectV2SingleSelectField { id name options { id name color description } }
    } } } }
  }
}
"""


def project_data() -> tuple[str, list[dict[str, Any]]]:
    user = graphql(PROJECT_QUERY, {"login": OWNER})["user"]
    return user["id"], [item for item in user["projectsV2"]["nodes"] if item]


def ensure_project() -> dict[str, Any]:
    owner_id, projects = project_data()
    matches = [project for project in projects if project["title"] == RESOURCE_NAME]
    if len(matches) > 1:
        raise CheckError(f"More than one GitHub Project is named {RESOURCE_NAME}")
    if not matches:
        mutation = """
        mutation($owner:ID!, $title:String!) {
          createProjectV2(input:{ownerId:$owner,title:$title}) { projectV2 { id number title url } }
        }
        """
        project = graphql(mutation, {"owner": owner_id, "title": RESOURCE_NAME})[
            "createProjectV2"
        ]["projectV2"]
        log(f"Created {project['url']}")
        _, projects = project_data()
        matches = [item for item in projects if item["id"] == project["id"]]
    project = matches[0]
    if project.get("closed") or project.get("public"):
        mutation = """
        mutation($id:ID!) {
          updateProjectV2(input:{projectId:$id,closed:false,public:false}) { projectV2 { id } }
        }
        """
        graphql(mutation, {"id": project["id"]})
    status_fields = [
        field
        for field in project["fields"]["nodes"]
        if field and field.get("name") == "Status"
    ]
    if len(status_fields) > 1:
        raise CheckError("The GitHub Project has more than one Status field")
    options = [
        {"name": "Accepted", "color": "GREEN", "description": "An accepted artifact"},
        {"name": "Ready", "color": "BLUE", "description": "A ready task"},
        {"name": "Withdrawn", "color": "RED", "description": "A withdrawn artifact"},
    ]
    if status_fields:
        existing = {option["name"]: option for option in status_fields[0]["options"]}
        for option in options:
            if option["name"] in existing:
                option["id"] = existing[option["name"]]["id"]
        mutation = """
        mutation($field:ID!, $options:[ProjectV2SingleSelectFieldOptionInput!]!) {
          updateProjectV2Field(input:{fieldId:$field,singleSelectOptions:$options}) {
            projectV2Field { ... on ProjectV2SingleSelectField { id } }
          }
        }
        """
        graphql(mutation, {"field": status_fields[0]["id"], "options": options})
    else:
        mutation = """
        mutation($project:ID!, $options:[ProjectV2SingleSelectFieldOptionInput!]!) {
          createProjectV2Field(input:{projectId:$project,name:"Status",dataType:SINGLE_SELECT,
            singleSelectOptions:$options}) {
            projectV2Field { ... on ProjectV2SingleSelectField { id } }
          }
        }
        """
        graphql(mutation, {"project": project["id"], "options": options})
    _, projects = project_data()
    return next(item for item in projects if item["id"] == project["id"])


def ensure_trello_board(api: TrelloApi) -> dict[str, Any]:
    boards = api.request("GET", "/members/me/boards?filter=all&fields=id,name,closed,url,prefs")
    matches = [board for board in boards if board["name"] == RESOURCE_NAME]
    if len(matches) > 1:
        raise CheckError(f"More than one Trello board is named {RESOURCE_NAME}")
    if not matches:
        board = api.request(
            "POST",
            "/boards",
            {
                "name": RESOURCE_NAME,
                "defaultLists": False,
                "prefs_permissionLevel": "private",
            },
        )
        log(f"Created {board['url']}")
    else:
        board = matches[0]
        if board.get("closed"):
            board = api.request("PUT", f"/boards/{board['id']}", {"closed": False})
    if board.get("prefs", {}).get("permissionLevel") != "private":
        board = api.request(
            "PUT", f"/boards/{board['id']}", {"prefs/permissionLevel": "private"}
        )
    lists = api.request("GET", f"/boards/{board['id']}/lists?filter=all")
    for status in STATUSES:
        open_matches = [item for item in lists if item["name"] == status and not item["closed"]]
        if len(open_matches) > 1:
            raise CheckError(f"The Trello board has duplicate open lists named {status}")
        if not open_matches:
            api.request(
                "POST", f"/boards/{board['id']}/lists", {"name": status, "pos": "bottom"}
            )
    return board


def set_secret(repository: str, name: str, value: str) -> None:
    run_command(["gh", "secret", "set", name, "--repo", repository], stdin=value)


def get_file(repository: str, path: str, ref: str | None = None) -> dict[str, Any] | None:
    suffix = f"?ref={urllib.parse.quote(ref)}" if ref else ""
    try:
        encoded_path = urllib.parse.quote(path, safe="/")
        return gh_api("GET", f"repos/{repository}/contents/{encoded_path}{suffix}")
    except CheckError as error:
        if "HTTP 404" in str(error):
            return None
        raise


def put_file(repository: str, path: str, content: str, branch: str, message: str) -> None:
    current = get_file(repository, path, branch)
    encoded = base64.b64encode(content.encode()).decode()
    if current and current.get("content"):
        old = base64.b64decode(current["content"]).decode()
        if old == content:
            return
    data: dict[str, Any] = {
        "message": message,
        "content": encoded,
        "branch": branch,
    }
    if current:
        data["sha"] = current["sha"]
    gh_api(
        "PUT",
        f"repos/{repository}/contents/{urllib.parse.quote(path, safe='/')}",
        data,
    )


def delete_file(repository: str, path: str, branch: str, message: str) -> None:
    current = get_file(repository, path, branch)
    if not current:
        return
    gh_api(
        "DELETE",
        f"repos/{repository}/contents/{urllib.parse.quote(path, safe='/')}",
        {"message": message, "sha": current["sha"], "branch": branch},
    )


def render_files(provider: str, state: dict[str, Any]) -> dict[str, str]:
    args = [
        "nix-instantiate",
        "--eval",
        "--strict",
        "--json",
        str(SCRIPT_DIR / "render.nix"),
        "--argstr",
        "provider",
        provider,
        "--argstr",
        "owner",
        OWNER,
        "--arg",
        "projectNumber",
        str(state.get("github_project", {}).get("number", 1)),
        "--argstr",
        "trelloBoard",
        state.get("trello_board", {}).get("id", "unused"),
    ]
    return json.loads(run_command(args))


def deploy(provider: str, state: dict[str, Any]) -> None:
    repository = repository_path(provider)
    default_branch = state["repositories"][provider]["default_branch"]
    files = render_files(provider, state)
    files["README.md"] = f"# {REPOSITORIES[provider]}\n\nLive E2E sandbox for Repofactory.\n"
    files["docs/artifact/README.md"] = "# Features\n"
    for path, content in files.items():
        put_file(repository, path, content, default_branch, "test: deploy generated integration")


def setup_environment(providers: list[str]) -> list[str]:
    names = ["GH_TOKEN"]
    if "trello" in providers:
        names.extend(["TRELLO_API_KEY", "TRELLO_TOKEN"])
    return names


def merge_setup_state(
    state: dict[str, Any],
    repositories: dict[str, dict[str, Any]],
    project: dict[str, Any] | None = None,
    board: dict[str, Any] | None = None,
) -> dict[str, Any]:
    for provider, data in repositories.items():
        state["repositories"][provider] = {
            "name": data["name"],
            "url": data["html_url"],
            "default_branch": data["default_branch"],
        }
    if project is not None:
        state["github_project"] = {
            "id": project["id"],
            "number": project["number"],
            "url": project["url"],
        }
    if board is not None:
        state["trello_board"] = {"id": board["id"], "url": board["url"]}
    return state


def setup(providers: list[str]) -> dict[str, Any]:
    need_environment(setup_environment(providers))
    ensure_github_account()
    state = load_setup_state()
    repositories = {
        provider: ensure_repository(REPOSITORIES[provider]) for provider in providers
    }
    project = None
    board = None
    if "github-projects" in providers:
        project = ensure_project()
    if "trello" in providers:
        board = ensure_trello_board(TrelloApi())
    merge_setup_state(state, repositories, project, board)
    for provider in providers:
        repository = repository_path(provider)
        if provider == "github-projects":
            set_secret(repository, "PROJECTS_TOKEN", os.environ["GH_TOKEN"])
        else:
            set_secret(repository, "TRELLO_API_KEY", os.environ["TRELLO_API_KEY"])
            set_secret(repository, "TRELLO_TOKEN", os.environ["TRELLO_TOKEN"])
        deploy(provider, state)
    save_state(state)
    if "github-projects" in providers:
        log(f"GitHub Project: {state['github_project']['url']}")
    if "trello" in providers:
        log(f"Trello board: {state['trello_board']['url']}")
    return state


def branch_sha(repository: str, branch: str) -> str:
    return gh_api("GET", f"repos/{repository}/git/ref/heads/{urllib.parse.quote(branch, safe='')}")[
        "object"
    ]["sha"]


def make_branch(repository: str, default_branch: str, name: str) -> None:
    gh_api(
        "POST",
        f"repos/{repository}/git/refs",
        {"ref": f"refs/heads/{name}", "sha": branch_sha(repository, default_branch)},
    )


def delete_branch(repository: str, name: str) -> None:
    try:
        gh_api(
            "DELETE",
            f"repos/{repository}/git/refs/heads/{urllib.parse.quote(name, safe='')}",
        )
    except CheckError as error:
        if "HTTP 404" not in str(error) and "HTTP 422" not in str(error):
            raise


def open_pull_request(repository: str, branch: str, base: str, title: str) -> dict[str, Any]:
    pull = gh_api(
        "POST",
        f"repos/{repository}/pulls",
        {"title": title, "head": branch, "base": base, "body": "Repofactory live E2E check."},
    )
    log(f"Pull request: {pull['html_url']}")
    return pull


def merge_pull_request(repository: str, pull: dict[str, Any]) -> tuple[str, float]:
    started = time.time()
    result = gh_api(
        "PUT",
        f"repos/{repository}/pulls/{pull['number']}/merge",
        {"merge_method": "squash"},
    )
    if not result.get("merged"):
        raise CheckError(f"GitHub did not merge pull request {pull['number']}")
    return result["sha"], started


def close_pull_request(repository: str, pull: dict[str, Any]) -> float:
    started = time.time()
    gh_api("PATCH", f"repos/{repository}/pulls/{pull['number']}", {"state": "closed"})
    return started


def workflow_runs(repository: str) -> list[dict[str, Any]]:
    result = gh_api(
        "GET", f"repos/{repository}/actions/workflows/{WORKFLOW}/runs?per_page=50"
    )
    return result["workflow_runs"]


def wait_for_workflow(
    repository: str,
    event: str,
    started: float,
    pull_number: int | None = None,
) -> dict[str, Any]:
    deadline = time.time() + WORKFLOW_TIMEOUT
    delay = 2.0
    candidate = None
    while time.time() < deadline:
        for run in workflow_runs(repository):
            created = datetime.fromisoformat(run["created_at"].replace("Z", "+00:00")).timestamp()
            pull_numbers = [item["number"] for item in run.get("pull_requests", [])]
            if run["event"] != event or created + 5 < started:
                continue
            if pull_number is not None and pull_numbers and pull_number not in pull_numbers:
                continue
            candidate = run
            if run["status"] == "completed":
                log(f"Workflow: {run['html_url']} ({run['conclusion']})")
                if run["conclusion"] not in ("success", "skipped"):
                    raise CheckError(
                        f"Workflow {run['html_url']} ended with {run['conclusion']}"
                    )
                return run
        time.sleep(delay)
        delay = min(delay * 1.5, 15.0)
    suffix = f": {candidate['html_url']}" if candidate else ""
    raise CheckError(f"The workflow did not complete in {WORKFLOW_TIMEOUT} seconds{suffix}")


def wait_for_run_attempt(repository: str, run_id: int, attempt: int) -> dict[str, Any]:
    deadline = time.time() + WORKFLOW_TIMEOUT
    delay = 2.0
    while time.time() < deadline:
        run = gh_api("GET", f"repos/{repository}/actions/runs/{run_id}")
        if run["run_attempt"] >= attempt and run["status"] == "completed":
            log(f"Workflow rerun: {run['html_url']} ({run['conclusion']})")
            if run["conclusion"] != "success":
                raise CheckError(f"Workflow rerun ended with {run['conclusion']}")
            return run
        time.sleep(delay)
        delay = min(delay * 1.5, 15.0)
    raise CheckError(f"The workflow rerun did not complete in {WORKFLOW_TIMEOUT} seconds")


def pull_comments(repository: str, number: int) -> list[dict[str, Any]]:
    return gh_api("GET", f"repos/{repository}/issues/{number}/comments?per_page=100")


def assert_managed_comment(repository: str, number: int, paths: list[str]) -> None:
    managed = [
        comment
        for comment in pull_comments(repository, number)
        if MANAGED_COMMENT in (comment.get("body") or "")
    ]
    if len(managed) != 1:
        raise CheckError(f"Pull request {number} must have one managed comment")
    for path in paths:
        if path not in managed[0]["body"]:
            raise CheckError(f"The managed comment does not include {path}")


def marker_path(repository: str, body: str) -> str | None:
    pattern = re.compile(
        rf"<!-- repofactory:artifact:{re.escape(repository)}:(.+) -->"
    )
    match = pattern.search(body or "")
    return match.group(1) if match else None


def retry_check(
    check: Callable[[], Any], timeout: float = 60.0, delay: float = 2.0
) -> Any:
    deadline = time.time() + timeout
    while True:
        try:
            return check()
        except CheckError:
            if time.time() >= deadline:
                raise
            time.sleep(delay)


def artifact_metadata(path: str) -> tuple[str, str | None]:
    source = Path(path)
    root = "/".join(source.parts[:3])
    relative = source.parts[3:]
    if relative == ("README.md",):
        return "feature-summary", None
    if relative == ("requirements", "README.md"):
        return "master-requirement", f"{root}/README.md"
    if relative[0:1] == ("requirements",) and source.name.startswith("req-"):
        return "requirement", f"{root}/requirements/README.md"
    if relative == ("tasks", "README.md"):
        return "implementation-plan", f"{root}/README.md"
    if relative[0:1] == ("tasks",) and source.name.startswith("task-"):
        return "task", f"{root}/tasks/README.md"
    raise CheckError(f"The Trello check cannot classify {path}")


class GitHubInspector:
    def __init__(self, repository: str, state: dict[str, Any]):
        self.repository = repository
        self.project_id = state["github_project"]["id"]

    def issues(self) -> dict[str, dict[str, Any]]:
        result: dict[str, dict[str, Any]] = {}
        page = 1
        while True:
            issues = gh_api(
                "GET",
                f"repos/{self.repository}/issues?state=all&per_page=100&page={page}",
            )
            for issue in issues:
                if "pull_request" in issue:
                    continue
                path = marker_path(self.repository, issue.get("body") or "")
                if path:
                    if path in result:
                        raise CheckError(f"Two GitHub issues use the marker for {path}")
                    result[path] = issue
            if len(issues) < 100:
                break
            page += 1
        return result

    def project(self) -> tuple[dict[str, str], dict[int, dict[str, Any]]]:
        query = """
        query($project:ID!, $after:String) { node(id:$project) { ... on ProjectV2 {
          fields(first:100) { nodes { ... on ProjectV2SingleSelectField {
            id name options { id name }
          } } }
          items(first:100,after:$after) {
            pageInfo { hasNextPage endCursor }
            nodes { id content { ... on Issue {
            databaseId number url repository { nameWithOwner }
          } } fieldValues(first:20) { nodes { ... on ProjectV2ItemFieldSingleSelectValue {
            name field { ... on ProjectV2FieldCommon { name } }
          } } } } }
        } } }
        """
        after = None
        project = None
        nodes: list[dict[str, Any]] = []
        while True:
            project = graphql(query, {"project": self.project_id, "after": after})["node"]
            nodes.extend(item for item in project["items"]["nodes"] if item)
            page = project["items"]["pageInfo"]
            if not page["hasNextPage"]:
                break
            after = page["endCursor"]
        status = next(
            field for field in project["fields"]["nodes"] if field and field.get("name") == "Status"
        )
        options = {item["name"]: item["id"] for item in status["options"]}
        items: dict[int, dict[str, Any]] = {}
        for item in nodes:
            content = item and item.get("content")
            if not content or content["repository"]["nameWithOwner"] != self.repository:
                continue
            values = {
                value["field"]["name"]: value["name"]
                for value in item["fieldValues"]["nodes"]
                if value and value.get("field") and "name" in value
            }
            item["values"] = values
            items[content["databaseId"]] = item
        return {"field": status["id"], **options}, items

    def set_status(self, path: str, status: str) -> None:
        issue = self.issues()[path]
        project, items = self.project()
        item = items[issue["id"]]
        mutation = """
        mutation($project:ID!, $item:ID!, $field:ID!, $option:String!) {
          updateProjectV2ItemFieldValue(input:{projectId:$project,itemId:$item,fieldId:$field,
            value:{singleSelectOptionId:$option}}) { projectV2Item { id } }
        }
        """
        graphql(
            mutation,
            {
                "project": self.project_id,
                "item": item["id"],
                "field": project["field"],
                "option": project[status],
            },
        )

    def assert_items(
        self,
        expected: dict[str, str],
        identities: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        def check() -> dict[str, Any]:
            issues = self.issues()
            project, items = self.project()
            selected = {path: issue for path, issue in issues.items() if path in expected}
            if set(selected) != set(expected):
                raise CheckError(
                    f"GitHub issue paths differ: expected {sorted(expected)}, "
                    f"got {sorted(selected)}"
                )
            result: dict[str, Any] = {}
            for path, status in expected.items():
                issue = selected[path]
                result[path] = issue["id"]
                if identities and path in identities and issue["id"] != identities[path]:
                    raise CheckError(f"GitHub changed the issue identity for {path}")
                item = items.get(issue["id"])
                if not item or item["values"].get("Status") != status:
                    raise CheckError(f"GitHub issue {path} does not have status {status}")
                kind, _ = artifact_metadata(path)
                labels = [label["name"] for label in issue.get("labels", [])]
                managed = [name for name in labels if name.startswith(LABEL_PREFIX)]
                if managed != [f"{LABEL_PREFIX}{kind}"]:
                    raise CheckError(f"GitHub issue {path} has incorrect type labels: {managed}")
            return result

        return retry_check(check)

    def assert_link(self, parent: str, child: str) -> None:
        issues = self.issues()
        subissues = gh_api(
            "GET",
            f"repos/{self.repository}/issues/{issues[parent]['number']}/sub_issues?per_page=100",
        )
        if not any(item["id"] == issues[child]["id"] for item in subissues):
            raise CheckError(f"GitHub did not link {child} below {parent}")

    def cleanup(self, feature_prefix: str = "docs/artifact/feat-e2e-") -> None:
        for path, issue in self.issues().items():
            if path.startswith(feature_prefix) and issue["state"] != "closed":
                gh_api(
                    "PATCH",
                    f"repos/{self.repository}/issues/{issue['number']}",
                    {"state": "closed"},
                )


class TrelloInspector:
    def __init__(self, repository: str, state: dict[str, Any], api: TrelloApi):
        self.repository = repository
        self.board = state["trello_board"]["id"]
        self.api = api

    def lists(self) -> dict[str, str]:
        lists = self.api.request("GET", f"/boards/{self.board}/lists?filter=all")
        return {item["name"]: item["id"] for item in lists if not item["closed"]}

    def labels(self) -> dict[str, str]:
        labels = self.api.request("GET", f"/boards/{self.board}/labels?limit=1000")
        return {item["id"]: item["name"] for item in labels}

    def cards(self) -> dict[str, dict[str, Any]]:
        cards = self.api.request(
            "GET",
            f"/boards/{self.board}/cards"
            "?filter=all&fields=id,name,desc,url,shortUrl,closed,idList,idLabels",
        )
        result: dict[str, dict[str, Any]] = {}
        for card in cards:
            path = marker_path(self.repository, card.get("desc") or "")
            if path:
                if path in result:
                    raise CheckError(f"Two Trello cards use the marker for {path}")
                result[path] = card
        return result

    def set_status(self, path: str, status: str) -> None:
        card = self.cards()[path]
        self.api.request("PUT", f"/cards/{card['id']}", {"idList": self.lists()[status]})

    def assert_items(
        self,
        expected: dict[str, str],
        identities: dict[str, Any] | None = None,
    ) -> dict[str, Any]:
        cards = self.cards()
        lists = self.lists()
        labels = self.labels()
        selected = {path: card for path, card in cards.items() if path in expected}
        if set(selected) != set(expected):
            raise CheckError(
                f"Trello card paths differ: expected {sorted(expected)}, got {sorted(selected)}"
            )
        result: dict[str, Any] = {}
        for path, status in expected.items():
            card = selected[path]
            result[path] = card["id"]
            if identities and path in identities and card["id"] != identities[path]:
                raise CheckError(f"Trello changed the card identity for {path}")
            if card["idList"] != lists[status]:
                raise CheckError(f"Trello card {path} does not have status {status}")
            description = card.get("desc") or ""
            kind, parent = artifact_metadata(path)
            managed = [
                labels[label_id]
                for label_id in card.get("idLabels", [])
                if labels.get(label_id, "").startswith(LABEL_PREFIX)
            ]
            if managed != [f"{LABEL_PREFIX}{kind}"]:
                raise CheckError(f"Trello card {path} has incorrect type labels: {managed}")
            required = [
                f"- Artifact: [`{path}`](",
                "- Accepted version: [",
                f"- Artifact type: `{kind}`",
                f"<!-- repofactory:artifact:{self.repository}:{path} -->",
            ]
            if parent:
                parent_card = cards.get(parent)
                if parent_card is None:
                    raise CheckError(f"Trello card {path} does not have its parent card")
                parent_url = parent_card.get("shortUrl") or parent_card["url"]
                required.append(f"- Parent artifact: [`{parent}`]({parent_url})")
            for value in required:
                if value not in description:
                    raise CheckError(f"Trello card {path} does not include {value}")
        return result

    def assert_link(self, parent: str, child: str) -> None:
        cards = self.cards()
        checklists = self.api.request(
            "GET", f"/cards/{cards[parent]['id']}/checklists?checkItems=all"
        )
        children = [item for item in checklists if item["name"] == "Children"]
        child_url = cards[child].get("shortUrl") or cards[child]["url"]
        if len(children) != 1 or not any(
            child_url in item["name"] for item in children[0].get("checkItems", [])
        ):
            raise CheckError(f"Trello did not link {child} below {parent}")

    def cleanup(self, feature_prefix: str = "docs/artifact/feat-e2e-") -> None:
        lists = self.lists()
        for path, card in self.cards().items():
            if path.startswith(feature_prefix) and not card["closed"]:
                self.api.request(
                    "PUT",
                    f"/cards/{card['id']}",
                    {"idList": lists["Withdrawn"], "closed": True},
                )


@dataclass
class Scenario:
    provider: str
    repository: str
    default_branch: str
    run_id: str
    feature: str
    root: str
    paths: dict[str, str]


def new_scenario(provider: str, state: dict[str, Any]) -> Scenario:
    run_id = datetime.now(UTC).strftime("%Y%m%d-%H%M%S-%f")
    feature = f"feat-e2e-{provider}-{run_id}"
    root = f"docs/artifact/{feature}"
    return Scenario(
        provider=provider,
        repository=repository_path(provider),
        default_branch=state["repositories"][provider]["default_branch"],
        run_id=run_id,
        feature=feature,
        root=root,
        paths={
            "feature": f"{root}/README.md",
            "requirements": f"{root}/requirements/README.md",
            "requirement": f"{root}/requirements/req-first.md",
            "tasks": f"{root}/tasks/README.md",
            "task": f"{root}/tasks/task-run.md",
        },
    )


def artifact_files(scenario: Scenario) -> dict[str, str]:
    return {
        scenario.paths["feature"]: f"# Feature: E2E {scenario.run_id}\n",
        scenario.paths["requirements"]: "# Requirements: E2E provider check\n",
        scenario.paths["requirement"]: "# req-first: Check the provider\n",
        scenario.paths["tasks"]: "# Implementation plan: E2E provider check\n",
        scenario.paths["task"]: "# task-run: Run the provider check\n",
    }


def create_pull(
    scenario: Scenario,
    name: str,
    changes: dict[str, str | None],
) -> dict[str, Any]:
    branch = f"e2e-{scenario.provider}-{scenario.run_id}-{name}"
    make_branch(scenario.repository, scenario.default_branch, branch)
    for path, content in changes.items():
        if content is None:
            delete_file(scenario.repository, path, branch, f"test: {name}")
        else:
            put_file(scenario.repository, path, content, branch, f"test: {name}")
    pull = open_pull_request(scenario.repository, branch, scenario.default_branch, f"test: {name}")
    pull["test_branch"] = branch
    return pull


def inspector_for(provider: str, state: dict[str, Any]) -> Any:
    repository = repository_path(provider)
    if provider == "github-projects":
        return GitHubInspector(repository, state)
    return TrelloInspector(repository, state, TrelloApi())


def expected_statuses(scenario: Scenario, requirement_path: str | None = None) -> dict[str, str]:
    paths = scenario.paths
    result = {
        paths["feature"]: "Accepted",
        paths["requirements"]: "Accepted",
        requirement_path or paths["requirement"]: "Accepted",
        paths["tasks"]: "Accepted",
        paths["task"]: "Ready",
    }
    return result


def assert_body_links(
    inspector: Any, scenario: Scenario, path: str, sha: str, pull_url: str
) -> None:
    items = inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
    body = (
        items[path].get("body")
        if isinstance(inspector, GitHubInspector)
        else items[path].get("desc")
    )
    body = body or ""
    for value in (f"blob/{scenario.default_branch}/{path}", f"blob/{sha}/{path}", pull_url):
        if value not in body:
            raise CheckError(f"The provider item for {path} does not include {value}")


def run_provider(provider: str, state: dict[str, Any]) -> dict[str, Any]:
    scenario = new_scenario(provider, state)
    inspector = inspector_for(provider, state)
    report: dict[str, Any] = {
        "provider": provider,
        "run_id": scenario.run_id,
        "repository": state["repositories"][provider]["url"],
        "scenarios": [],
    }

    def record(name: str, callback: Callable[[], None]) -> None:
        started = time.time()
        callback()
        report["scenarios"].append(
            {"name": name, "status": "passed", "duration_seconds": round(time.time() - started, 2)}
        )
        log(f"PASS {provider}: {name}")

    initial_items = (
        inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
    )
    initial_paths = set(initial_items)

    def rejected() -> None:
        pull = create_pull(
            scenario,
            "rejected",
            {scenario.paths["feature"]: artifact_files(scenario)[scenario.paths["feature"]]},
        )
        started = close_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        items = inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
        now = set(items)
        if now != initial_paths:
            raise CheckError("A rejected pull request changed provider items")

    record("rejected pull request", rejected)

    def non_artifact() -> None:
        pull = create_pull(
            scenario,
            "non-artifact",
            {"notes.txt": f"E2E {scenario.run_id}\n"},
        )
        _, started = merge_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        items = inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
        now = set(items)
        if now != initial_paths:
            raise CheckError("A non-artifact pull request changed provider items")

    record("non-artifact pull request", non_artifact)

    create_result: dict[str, Any] = {}

    def create_tree() -> None:
        pull = create_pull(scenario, "create", artifact_files(scenario))
        sha, started = merge_pull_request(scenario.repository, pull)
        run = wait_for_workflow(
            scenario.repository, "pull_request_target", started, pull["number"]
        )
        delete_branch(scenario.repository, pull["test_branch"])
        expected = expected_statuses(scenario)
        identities = inspector.assert_items(expected)
        inspector.assert_link(scenario.paths["feature"], scenario.paths["requirements"])
        inspector.assert_link(scenario.paths["requirements"], scenario.paths["requirement"])
        inspector.assert_link(scenario.paths["feature"], scenario.paths["tasks"])
        inspector.assert_link(scenario.paths["tasks"], scenario.paths["task"])
        assert_body_links(inspector, scenario, scenario.paths["requirement"], sha, pull["html_url"])
        assert_managed_comment(scenario.repository, pull["number"], list(expected))
        create_result.update({"pull": pull, "run": run, "identities": identities})

    record("create artifact tree", create_tree)

    def rerun() -> None:
        run = create_result["run"]
        gh_api("POST", f"repos/{scenario.repository}/actions/runs/{run['id']}/rerun")
        wait_for_run_attempt(scenario.repository, run["id"], run["run_attempt"] + 1)
        inspector.assert_items(expected_statuses(scenario), create_result["identities"])
        assert_managed_comment(
            scenario.repository,
            create_result["pull"]["number"],
            list(expected_statuses(scenario)),
        )

    record("workflow rerun", rerun)

    def full_scan() -> None:
        started = time.time()
        gh_api(
            "POST",
            f"repos/{scenario.repository}/actions/workflows/{WORKFLOW}/dispatches",
            {"ref": scenario.default_branch},
        )
        wait_for_workflow(scenario.repository, "workflow_dispatch", started)
        inspector.assert_items(expected_statuses(scenario), create_result["identities"])

    record("manual full scan", full_scan)

    def update_artifact() -> None:
        inspector.set_status(scenario.paths["feature"], "Ready")
        pull = create_pull(
            scenario,
            "update",
            {scenario.paths["feature"]: f"# Feature: Changed E2E {scenario.run_id}\n"},
        )
        _, started = merge_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        expected = expected_statuses(scenario)
        expected[scenario.paths["feature"]] = "Ready"
        inspector.assert_items(expected, create_result["identities"])

    record("update and preserve status", update_artifact)

    renamed = f"{scenario.root}/requirements/req-renamed.md"

    def rename_artifact() -> None:
        content = artifact_files(scenario)[scenario.paths["requirement"]]
        pull = create_pull(
            scenario,
            "rename",
            {renamed: content, scenario.paths["requirement"]: None},
        )
        files = gh_api(
            "GET", f"repos/{scenario.repository}/pulls/{pull['number']}/files?per_page=100"
        )
        renamed_files = [item for item in files if item["filename"] == renamed]
        if len(renamed_files) != 1 or renamed_files[0]["status"] != "renamed":
            raise CheckError("GitHub did not classify the artifact change as a rename")
        _, started = merge_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        expected = expected_statuses(scenario, renamed)
        expected[scenario.paths["feature"]] = "Ready"
        identities = dict(create_result["identities"])
        identities[renamed] = identities.pop(scenario.paths["requirement"])
        inspector.assert_items(expected, identities)
        create_result["identities"] = identities

    record("rename artifact", rename_artifact)

    def delete_artifact() -> None:
        pull = create_pull(scenario, "delete", {renamed: None})
        _, started = merge_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        items = inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
        item = items[renamed]
        inspector.assert_items(
            {renamed: "Withdrawn"},
            {renamed: create_result["identities"][renamed]},
        )
        if isinstance(inspector, GitHubInspector):
            if item["state"] != "closed":
                raise CheckError("GitHub did not close the withdrawn issue")
        elif not item["closed"]:
            raise CheckError("Trello did not archive the withdrawn card")

    record("withdraw artifact", delete_artifact)

    def cleanup_tree() -> None:
        remaining = {
            path: None
            for path in artifact_files(scenario)
            if path != scenario.paths["requirement"]
        }
        pull = create_pull(scenario, "cleanup", remaining)
        _, started = merge_pull_request(scenario.repository, pull)
        wait_for_workflow(scenario.repository, "pull_request_target", started, pull["number"])
        delete_branch(scenario.repository, pull["test_branch"])
        items = inspector.issues() if isinstance(inspector, GitHubInspector) else inspector.cards()
        expected = {
            path: "Withdrawn"
            for path in [
                scenario.paths["feature"],
                scenario.paths["requirements"],
                renamed,
                scenario.paths["tasks"],
                scenario.paths["task"],
            ]
        }
        inspector.assert_items(expected, create_result["identities"])
        for path, item in items.items():
            if not path.startswith(scenario.root):
                continue
            closed = (
                item["state"] == "closed"
                if isinstance(inspector, GitHubInspector)
                else item["closed"]
            )
            if not closed:
                raise CheckError(f"Cleanup did not close or archive {path}")

    record("cleanup artifact tree", cleanup_tree)
    return report


def repository_tree(repository: str, branch: str) -> list[str]:
    sha = branch_sha(repository, branch)
    tree = gh_api("GET", f"repos/{repository}/git/trees/{sha}?recursive=1")
    return [item["path"] for item in tree["tree"] if item["type"] == "blob"]


def cleanup_provider(provider: str, state: dict[str, Any]) -> None:
    repository = repository_path(provider)
    branch = state["repositories"][provider]["default_branch"]
    for path in repository_tree(repository, branch):
        if path.startswith("docs/artifact/feat-e2e-"):
            delete_file(repository, path, branch, "test: recover E2E sandbox")
    refs = gh_api("GET", f"repos/{repository}/git/matching-refs/heads/e2e-")
    for ref in refs:
        name = ref["ref"].removeprefix("refs/heads/")
        delete_branch(repository, name)
    inspector_for(provider, state).cleanup()
    log(f"Cleaned {repository}")


def write_report(report: dict[str, Any]) -> Path:
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    name = datetime.now(UTC).strftime("%Y%m%d-%H%M%S-%f") + ".json"
    path = RESULTS_DIR / name
    path.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    return path


def add_provider_argument(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--provider",
        choices=("all", "github-projects", "trello"),
        default="all",
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    setup_parser = subparsers.add_parser(
        "setup", help="Create or check the live test resources"
    )
    add_provider_argument(setup_parser)
    for command in ("test", "cleanup"):
        child = subparsers.add_parser(command, help=f"{command.title()} the live test resources")
        add_provider_argument(child)
    return parser.parse_args()


def selected_providers(value: str) -> list[str]:
    return list(REPOSITORIES) if value == "all" else [value]


def check_provider_state(provider: str, state: dict[str, Any]) -> None:
    if provider not in state.get("repositories", {}):
        raise CheckError(f"Run setup for {provider} before this command")
    resource = "github_project" if provider == "github-projects" else "trello_board"
    if resource not in state:
        raise CheckError(f"Run setup for {provider} before this command")


def collect_provider_reports(
    providers: list[str], check: Callable[[str], dict[str, Any]]
) -> tuple[list[dict[str, Any]], list[str]]:
    reports: list[dict[str, Any]] = []
    errors: list[str] = []
    for provider in providers:
        try:
            reports.append(check(provider))
        except (CheckError, KeyError, OSError, ValueError) as error:
            message = str(error)
            reports.append({"provider": provider, "status": "failed", "error": message})
            errors.append(f"{provider}: {message}")
            log(f"FAIL {provider}: {message}")
    return reports, errors


def main() -> int:
    args = parse_args()
    try:
        providers = selected_providers(args.provider)
        if args.command == "setup":
            setup(providers)
            return 0
        need_environment(["GH_TOKEN"])
        state = load_state()
        if state.get("owner") != OWNER:
            raise CheckError(f"The state file must use the GitHub account {OWNER}")
        ensure_github_account()
        if "trello" in providers:
            need_environment(["TRELLO_API_KEY", "TRELLO_TOKEN"])
        for provider in providers:
            check_provider_state(provider, state)
        if args.command == "cleanup":
            for provider in providers:
                cleanup_provider(provider, state)
            return 0
        report = {
            "started_at": datetime.now(UTC).isoformat(),
            "status": "passed",
            "providers": [],
        }
        try:
            def check(provider: str) -> dict[str, Any]:
                deploy(provider, state)
                return run_provider(provider, state)

            provider_reports, provider_errors = collect_provider_reports(providers, check)
            report["providers"].extend(provider_reports)
            if provider_errors:
                raise CheckError("; ".join(provider_errors))
        except (CheckError, KeyError, OSError, ValueError) as error:
            report["status"] = "failed"
            report["error"] = str(error)
            raise
        finally:
            report["finished_at"] = datetime.now(UTC).isoformat()
            path = write_report(report)
            log(f"Result: {path}")
        return 0
    except (CheckError, KeyError, OSError, ValueError) as error:
        print(f"accepted-artifact-issues-e2e: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
