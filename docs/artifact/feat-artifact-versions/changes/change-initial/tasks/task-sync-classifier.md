# task-sync-classifier: Classify change paths in the synchronizer

**Plan:** [Implementation plan](README.md)
**Covers:** req-sync-ignores-versions, spec-sync-classifier
**Context:** context-factory

## Goal

`sync.py` classifies only the feature README and the files inside a change, ignores `versions/`, and stops on the old root layout.

## Steps

All paths are under `services/factory/composition/artifact-driven/`.

1. In `_assets/project-issues/sync.py`, add the constant `IGNORED_FOLDERS = ("versions",)` next
   to `ARTIFACT_KINDS`.
2. In `is_feature_markdown`, return `False` when `parts[3]` is in `IGNORED_FOLDERS`.
3. Replace `_standard_artifact(prefix, rest, full_path)` with
   `_change_artifact(feature_root, change_root, rest, path)`. The function returns the kind and
   the parent of the table `### Classification` of spec-sync-classifier. The parent of a leaf is
   the master `README.md` of the same folder in the same change. The parent of a decision is
   `<change_root>/specifications/<related>.md`.
4. In `classify_artifact`, classify only two forms: `feat-*/README.md` as `feature-summary` with
   parent `None`, and `feat-*/changes/change-*/<rest>` through `_change_artifact`. Remove the
   `parent.replace(feature_root, change_root, 1)` rewrite. Return `None` for every other path.
5. In `Synchronizer.run`, build `unsupported` from `item["filename"]` only, for the items whose
   `status` is not `removed`. Do not read `previous_filename` in the guard. Keep the message
   `Unsupported feature artifact paths: <paths>`.
6. In `GitHubAdapter.link`, change the `POST` body to
   `{"sub_issue_id": child.id, "replace_parent": True}`.
7. Do not change `ARTIFACT_KINDS`, the label colors, `IMPLEMENTATION_KINDS`, or `notify.py`.
8. In `_assets/project-issues/project-issues.md`, add the two rows of section
   `### The guide project-issues.md` of spec-sync-classifier to the `## Lifecycle` table.
9. In the same file, add the section `## Synchronized files` and the note
   "Migrate an existing repository" with the content of that section. Keep verbatim the
   `notification.uses` lines and the notification sentences that `notificationGuidesMatch` matches.
10. In `tests/test_sync.py`, move the fixture paths of these 11 tests from
    `docs/artifact/feat-<name>/<folder>/` to `docs/artifact/feat-<name>/changes/change-initial/<folder>/`:
    `test_requirement_tree`, `test_specification_and_task_tree`,
    `test_decision_uses_related_specification_as_parent`, `test_body_has_parent_path_and_link`,
    `test_upsert_replaces_managed_label_and_preserves_user_label`,
    `test_upsert_moves_existing_task_and_keeps_identity`, `test_sync_builds_parent_chain_before_leaf`
    (four upserts and three links), `test_unchanged_parent_is_not_updated`,
    `test_run_writes_changed_artifacts_without_implicit_parents`,
    `test_withdraw_uses_configured_status`, and `test_withdraw_keeps_parent_description_metadata`.
11. In `test_decision_uses_related_specification_as_parent`, patch
    `mock.patch.object(MODULE, "related_specification", return_value="spec-sync-workflow")`.
12. Add these 9 tests with the expectations of table `(c)` of spec-sync-classifier:
    `test_change_initial_is_an_ordinary_change`, `test_root_level_folders_are_unsupported`,
    `test_versions_are_ignored_in_pull_request`, `test_versions_are_ignored_in_manual_scan`,
    `test_unmigrated_tree_fails_manual_scan`, `test_rename_from_root_path_keeps_identity`,
    `test_removed_root_path_is_ignored`, `test_unsupported_change_path_fails`, and
    `test_link_sends_replace_parent`.
13. In `tests/test_notify.py`, lines 34, 35, and 68, change the fixture paths
    `docs/artifact/feat-login/tasks/task-new.md` and `docs/artifact/feat-login/tasks/task-old.md`
    to `docs/artifact/feat-login/changes/change-initial/tasks/...`. The assertions do not change.

## Check

Run from the repository root in a shell with Python, for example
`nix-shell -p python3 --run "python3 -m unittest services/factory/composition/artifact-driven/tests/test_sync.py services/factory/composition/artifact-driven/tests/test_notify.py"`.
All 31 tests of `test_sync.py` and all tests of `test_notify.py` pass.
`nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`
passes (`notificationGuidesMatch`).
