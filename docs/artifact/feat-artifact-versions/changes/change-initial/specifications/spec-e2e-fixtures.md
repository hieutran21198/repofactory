# spec-e2e-fixtures: Live check fixtures of the synchronizer

**Master:** [Specifications](README.md)
**Covers:** req-sync-ignores-versions
**Context:** context-factory

## Description

The live check `e2e/accepted-artifact-issues/e2e.py` runs the accepted-artifact workflow against
a real GitHub repository and a real project provider. Its fixture tree follows the layout of
[spec-artifact-layout](spec-artifact-layout.md). A new scenario shows that a pull request that adds
a version folder succeeds and makes no project item. The unit test `test_e2e.py` checks the fixture
and the metadata classifier without a network. The component `e2e/` has no dedicated
implementation expert; the solution expert wrote this contract.

## Contract

### Fixture tree

`new_scenario` gives a `Scenario` with `root = docs/artifact/<feature>` and these paths:

| Key | Path | Content (first line) | Expected status |
| --- | --- | --- | --- |
| `feature` | `<root>/README.md` | `# Feature: E2E <run_id>` | Accepted |
| `change` | `<root>/changes/change-initial/README.md` | `# Change: Initial` | Accepted |
| `requirements` | `<root>/changes/change-initial/requirements/README.md` | `# Requirements: E2E provider check` | Accepted |
| `requirement` | `<root>/changes/change-initial/requirements/req-first.md` | `# req-first: Check the provider` | Accepted |
| `tasks` | `<root>/changes/change-initial/tasks/README.md` | `# Implementation plan: E2E provider check` | Accepted |
| `task` | `<root>/changes/change-initial/tasks/task-run.md` | `# task-run: Run the provider check` | Ready |

`artifact_files` returns one entry for each path. `expected_statuses` returns one entry for each
path with the status above. The set of keys of both functions is equal.

The renamed path of the rename scenario is
`<root>/changes/change-initial/requirements/req-renamed.md`.

### Metadata classifier

`artifact_metadata(path)` classifies on the parts after the feature folder, `parts[3:]`:

| `parts[3:]` | Kind | Parent |
| --- | --- | --- |
| `README.md` | `feature-summary` | None |
| `changes/change-*/README.md` | `change-summary` | `<root>/README.md` |
| `changes/change-*/requirements/README.md` | `master-requirement` | The change README |
| `changes/change-*/requirements/req-*.md` | `requirement` | `<root>/changes/change-*/requirements/README.md` |
| `changes/change-*/tasks/README.md` | `implementation-plan` | The change README |
| `changes/change-*/tasks/task-*.md` | `task` | `<root>/changes/change-*/tasks/README.md` |
| Any other value, including a root-level `requirements/req-*.md` and a `versions/**` path | Raises `CheckError` | - |

### Links of the create scenario

`create_tree` asserts these parent-child links after the merge:

1. `feature` → `change`
2. `change` → `requirements`
3. `requirements` → `requirement`
4. `change` → `tasks`
5. `tasks` → `task`

The managed comment of the pull request lists each path of `expected_statuses`.

### New scenario: version snapshot

The scenario `version snapshot` runs after `create artifact tree` and before `rerun`:

1. Open a pull request that adds two files: `<root>/versions/1.0.0/requirements/README.md` and
   `<root>/versions/1.0.0/requirements/req-first.md`, each with the content of the file with the
   same name in `changes/change-initial/`.
2. Merge the pull request. Wait for the `pull_request_target` run. The run concludes with
   `success`.
3. Assert that the provider has no item whose path starts with `<root>/versions/`.
4. Assert that the items of `expected_statuses` are unchanged and keep their identities.
5. Assert that the pull request has no comment that contains `MANAGED_COMMENT`.
6. Delete the test branch.

The later `full scan` scenario runs with the version files on the default branch. It asserts the
same items as before. It shows that the manual scan ignores `versions/`.

### Cleanup

`cleanup_tree` deletes every remaining fixture file in one pull request: the feature README, the
change README, the master requirement, the renamed requirement, the plan, the task, and the two
version files. It expects the status `Withdrawn` for the six artifact paths and expects no item
for the two version files. Each item under `<root>` is closed or archived after the run.

`cleanup_provider` removes each file under `docs/artifact/feat-e2e-` from the default branch,
including `versions/` files.

### Unit tests in `test_e2e.py`

| Test | Expectation |
| --- | --- |
| `test_fixture_has_the_expected_tree_and_statuses` | The keys of `artifact_files` equal the keys of `expected_statuses`; `task` is `Ready`; `feature` and `change` are `Accepted`; each path except `feature` contains `/changes/change-initial/`. |
| `test_classifies_trello_description_metadata` | The change README is `("change-summary", "<root>/README.md")`; the requirement is `("requirement", "<root>/changes/change-initial/requirements/README.md")`; a root-level `<root>/requirements/req-a.md` raises `CheckError`; `<root>/versions/1.0.0/requirements/req-a.md` raises `CheckError`. |

The other tests of `test_e2e.py` are unchanged.

## Errors

- The workflow run of the version snapshot scenario does not conclude with `success`: the check
  fails with the run URL.
- The provider has an item under `<root>/versions/`: the check fails and names the path.
- The pull request of the version snapshot has a managed comment: the check fails.
