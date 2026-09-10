# task-e2e-fixtures: Move the live check fixtures into a change

**Plan:** [Implementation plan](README.md)
**Covers:** req-sync-ignores-versions, spec-e2e-fixtures
**Context:** context-factory

## Goal

The live check `e2e/accepted-artifact-issues/e2e.py` writes its fixture tree under
`changes/change-initial/`, classifies the paths of that tree, and shows that a version folder
makes no project item.

## Steps

1. In `e2e/accepted-artifact-issues/e2e.py`, change `new_scenario`. Keep `root = docs/artifact/<feature>`.
   Give the six keys and paths of the fixture table of spec-e2e-fixtures: `feature`, `change`,
   `requirements`, `requirement`, `tasks`, and `task`. The key `change` is new.
2. Change `artifact_files` so that it returns one entry for each key, with the first line of the
   table. The change README starts with `# Change: Initial`.
3. Change `expected_statuses` so that it returns one entry for each key. `task` is `Ready`. The
   other keys are `Accepted`.
4. Change the renamed path of `rename_artifact` to
   `<root>/changes/change-initial/requirements/req-renamed.md`.
5. Change `artifact_metadata` so that it classifies on `parts[3:]` with the table of
   spec-e2e-fixtures. Add the kind `change-summary` with the parent `<root>/README.md`. Give the
   change README as the parent of the master requirement and of the plan. Raise `CheckError` for
   every other path, including a root-level `requirements/req-*.md` path and a `versions/**` path.
6. Change `create_tree` so that it asserts the five parent-child links of spec-e2e-fixtures:
   `feature` to `change`, `change` to `requirements`, `requirements` to `requirement`, `change` to
   `tasks`, and `tasks` to `task`. The managed comment lists each path of `expected_statuses`.
7. Add the scenario `version snapshot` after `create artifact tree` and before `rerun`. Do the six
   steps of spec-e2e-fixtures: open a pull request that adds
   `<root>/versions/1.0.0/requirements/README.md` and
   `<root>/versions/1.0.0/requirements/req-first.md` with the content of the files with the same
   name in `changes/change-initial/`; merge it; wait for the `pull_request_target` run and assert
   `success`; assert that the provider has no item whose path starts with `<root>/versions/`;
   assert that the items of `expected_statuses` are unchanged and keep their identities; assert
   that the pull request has no comment that contains `MANAGED_COMMENT`; delete the branch.
8. Keep `full_scan` as it is. It runs with the version files on the default branch and asserts
   the same items as before.
9. Change `cleanup_tree` so that it deletes the eight remaining fixture files in one pull request:
   the six artifact paths and the two version files. Expect `Withdrawn` for the six artifact
   paths. Expect no item for the two version files.
10. Change `cleanup_provider` so that it removes each file under `docs/artifact/feat-e2e-`,
    including the `versions/` files.
11. In `e2e/accepted-artifact-issues/test_e2e.py`, change `test_fixture_has_the_expected_tree_and_statuses`
    and `test_classifies_trello_description_metadata` to the expectations of spec-e2e-fixtures.
    Do not change the other tests.

## Check

1. Enter `e2e/` and start the shell with `devenv shell`, or use `nix-shell -p python3`. Run
   `python3 accepted-artifact-issues/test_e2e.py` from `e2e/`. Each test passes.
2. Live check, only when the two provider sandboxes are configured with `GH_TOKEN`,
   `TRELLO_API_KEY`, and `TRELLO_TOKEN` (see `e2e/README.md`): run
   `python3 accepted-artifact-issues/e2e.py test` from `e2e/`. Each provider passes. The
   `version snapshot` scenario reports a run that concludes with `success`, no item under
   `<root>/versions/`, and no managed comment.
