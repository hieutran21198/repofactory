# req-sync-ignores-versions: The synchronizer follows the new layout

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

The accepted-artifact synchronizer must create an issue or a card for the feature README, for each
change README, and for each artifact inside a change. It must create nothing for a file under
`versions/`: no issue, no comment line, and no notification. The root folders
`feat-<name>/requirements/`, `feat-<name>/specifications/`, `feat-<name>/decisions/`, and
`feat-<name>/tasks/` are no longer a supported form. The synchronizer must stop with an error on
them, so that an incomplete migration is visible.

## Acceptance criteria

- Given a merged pull request that adds a change with its artifacts, when the synchronizer runs, then it creates one issue for the feature README, one issue for the change README, and one issue for each artifact inside the change.
- Given a merged pull request that adds or changes a file under `versions/`, when the synchronizer runs, then it creates no issue, no comment line, and no notification for that file.
- Given a feature with a root `requirements/`, `specifications/`, `decisions/`, or `tasks/` folder, when the synchronizer runs, then it stops with an error that names the feature and the folder.

## Notes

A version folder is a copy of accepted artifacts. An issue for a copy is a duplicate.
