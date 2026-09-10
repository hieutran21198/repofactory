# spec-sync-classifier: Synchronizer path classification

**Master:** [Specifications](README.md)
**Covers:** req-sync-ignores-versions
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The synchronizer `sync.py` classifies each Markdown path under `docs/artifact/feat-*` into one
artifact kind and one parent. The classification follows the layout of
[spec-artifact-layout](spec-artifact-layout.md). The synchronizer filters a path under
`versions/` before any kind lookup. The legacy root layout (`feat-<name>/requirements/`,
`specifications/`, `decisions/`, `tasks/`) is not a supported form.

The source is `services/factory/composition/artifact-driven/_assets/project-issues/sync.py`. The
guide is `project-issues.md` in the same folder. The tests are in
`services/factory/composition/artifact-driven/tests/test_sync.py`.

The synchronizer contract of the feature `feat-accepted-artifact-issues` (`spec-artifact-tree`) is
replaced by a change of that feature, `changes/change-artifact-versions/`, with the same table as
this specification. This specification is the behaviour of the code.

## Contract

### Constants and filter

- `IGNORED_FOLDERS = ("versions",)`.
- `is_feature_markdown(path)` returns `False` when `parts[3]` (the first segment after
  `feat-<name>`) is in `IGNORED_FOLDERS`. A path under `versions/` is not a feature Markdown
  path. It is not unsupported and it is not relevant.
- `ARTIFACT_KINDS`, `GITHUB_LABEL_COLORS`, `TRELLO_LABEL_COLORS`, `IMPLEMENTATION_KINDS`, the
  `artifact-status.*` options of the composition, and `notify.py` do not change. No new kind
  is added.

### Classification

`classify_artifact(path)` returns the kind and the parent from this table. `feat-*` is the
feature root `docs/artifact/feat-<name>`. "The master in the same change" is the `README.md` of
the same folder in the same change.

| Path | Type | Parent |
| --- | --- | --- |
| `feat-*/README.md` | `feature-summary` | None |
| `feat-*/changes/change-*/README.md` | `change-summary` | `feat-*/README.md` |
| `feat-*/changes/change-*/requirements/README.md` | `master-requirement` | `feat-*/changes/change-*/README.md` |
| `feat-*/changes/change-*/requirements/req-*.md` | `requirement` | The master in the same change |
| `feat-*/changes/change-*/specifications/README.md` | `master-specification` | `feat-*/changes/change-*/README.md` |
| `feat-*/changes/change-*/specifications/spec-*.md` | `specification` | The master in the same change |
| `feat-*/changes/change-*/decisions/adr-*.md` | `decision` | `feat-*/changes/change-*/specifications/<spec>.md`, where `<spec>` is the value of `**Relates to:**` in the decision |
| `feat-*/changes/change-*/tasks/README.md` | `implementation-plan` | `feat-*/changes/change-*/README.md` |
| `feat-*/changes/change-*/tasks/task-*.md` | `task` | The plan in the same change |
| `feat-*/versions/**` | Not an artifact (`None`). Never unsupported. | — |
| Any other `feat-*/**/*.md` | Not an artifact (`None`). Unsupported. | — |

The last row includes the legacy root paths `feat-*/requirements/**`, `feat-*/specifications/**`,
`feat-*/decisions/**`, and `feat-*/tasks/**`. It also includes a path in a change that is not in
the table, for example `feat-*/changes/change-x/notes.md`.

`change-initial` is an ordinary change. The table has no special case for it.

Implementation shape: one function `_change_artifact(feature_root, change_root, rest, path)`
replaces `_standard_artifact` and the string rewrite of the parent in `classify_artifact`. Only
the two forms `feat-*/README.md` and `feat-*/changes/change-*/<standard>` classify.

### The run

`Synchronizer.run()` applies these rules to the changed files of the pull request:

- The `unsupported` guard checks only `item["filename"]` of the items whose status is not
  `removed`. It does not check `previous_filename`. It does not check a removed item. A removed
  legacy path or a legacy `previous_filename` does not stop the run.
- When the guard finds a path, the run stops with the message
  `Unsupported feature artifact paths: <paths>`. The message names each path.
- A path under `versions/` is not unsupported and not relevant. A pull request that touches only
  `versions/` prints `No accepted feature artifacts need synchronization`. It creates no issue and
  no managed comment. The result file has an empty `artifacts` list, so `notify.py` sends
  nothing.
- A rename from a legacy root path to a change path (`previous_filename` is a legacy path,
  `filename` is in a change) keeps the issue identity through `old_path`. This is the existing
  upsert behaviour.

The manual full scan (`changed_files()` without a pull request, glob `feat-*/**/*.md`) obeys the
same rules. The scan skips each path under `versions/`. A root-level legacy path stops the scan
with the same message.

### The GitHub link

`GitHubAdapter.link` sends this body in the `POST` to
`/repos/<repo>/issues/<parent>/sub_issues`:

```json
{"sub_issue_id": <id>, "replace_parent": true}
```

Without `replace_parent`, GitHub answers HTTP 422 when a moved file gets a new parent.

### The guide `project-issues.md`

- In `## Lifecycle`, add these rows to the table:

  ```markdown
  | Add or change a file under `versions/` | Make no project change. |
  | Add or change a file in an unsupported path | Stop with an error that names the path. |
  ```

- Add a section `## Synchronized files`. It lists what the workflow synchronizes: the feature
  README, each change README, and each artifact inside a change. It lists what the workflow does
  not synchronize: `versions/`, the global index `docs/artifact/README.md`, and a file that is
  not Markdown. It says that the manual scan stops on a tree that keeps root-level folders.
- Add a note "Migrate an existing repository". Move the root folders to
  `changes/change-initial/` in one pull request with `git mv`. A renamed card keeps its identity.
  Add `versions/` in a later pull request.
- Keep verbatim the lines that the composition check matches. At minimum:
  the `notification.uses = [ "google-chat" "telegram" ];` line and the sentence
  `Set \`notification.uses\` to the required providers. The supported providers are
  \`"google-chat"\`, \`"slack"\`, and \`"telegram"\`.`, and the notification sentences
  `The notification includes added, updated, renamed, and withdrawn artifacts. Manual scans and
  pull requests without artifact changes send no notification.`

### The tests `test_sync.py`

(a) The fixture paths of these tests move from `docs/artifact/feat-login/<folder>/...` to
`docs/artifact/feat-login/changes/change-initial/<folder>/...`, and from
`docs/artifact/feat-accepted-artifact-issues/<folder>/...` to
`docs/artifact/feat-accepted-artifact-issues/changes/change-initial/<folder>/...`:

- `test_requirement_tree`
- `test_specification_and_task_tree`
- `test_decision_uses_related_specification_as_parent`
- `test_body_has_parent_path_and_link`
- `test_upsert_replaces_managed_label_and_preserves_user_label`
- `test_upsert_moves_existing_task_and_keeps_identity`
- `test_sync_builds_parent_chain_before_leaf` (the chain becomes feature README, change README,
  master, leaf: four upserts and three links)
- `test_unchanged_parent_is_not_updated`
- `test_run_writes_changed_artifacts_without_implicit_parents`
- `test_withdraw_uses_configured_status`
- `test_withdraw_keeps_parent_description_metadata`

(b) `test_decision_uses_related_specification_as_parent` uses
`mock.patch.object(MODULE, "related_specification", return_value="spec-sync-workflow")`. It does
not read a file of the repository.

(c) New tests, each with its expectation:

| Test | Expectation |
| --- | --- |
| `test_change_initial_is_an_ordinary_change` | A path in `changes/change-initial/` classifies with the same kind and parent form as any other change. |
| `test_root_level_folders_are_unsupported` | `classify_artifact` returns `None` for a root-level path, and `run()` fails with a message that names the path. |
| `test_versions_are_ignored_in_pull_request` | A pull request with only `versions/` paths has no relevant item and writes an empty `artifacts` list. |
| `test_versions_are_ignored_in_manual_scan` | A temporary tree with only `versions/` gives no relevant item. |
| `test_unmigrated_tree_fails_manual_scan` | A temporary tree with a root `requirements/` folder raises `RuntimeError`. |
| `test_rename_from_root_path_keeps_identity` | A rename from a root path to a change path calls upsert with the legacy path as `old_path`. |
| `test_removed_root_path_is_ignored` | A removed root path does not stop the run and produces no upsert. |
| `test_unsupported_change_path_fails` | `changes/change-x/notes.md` stops the run with a message that names the path. |
| `test_link_sends_replace_parent` | The `POST` body to `sub_issues` has `"replace_parent": true`. |

## Errors

- Stop if an accepted Markdown path in a change does not match a supported artifact form. The
  message names each path.
- Stop if a feature keeps a root-level artifact folder (`requirements/`, `specifications/`,
  `decisions/`, or `tasks/`). The message names each path.
- Stop if a decision does not name one related specification.
- Stop if a required parent artifact does not exist on the default branch.
