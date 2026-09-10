# req-no-status: No artifact records a status

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

No artifact of the new layout must record a status or a phase-tracking field. A version number is
not a status.

## Acceptance criteria

- Given a feature README, a change README, or a version folder, when a reader searches for a status or a phase-tracking field, then the reader finds none.
- Given a feature README, when a reader opens it, then the current version and the version table are the only records of progress.

## Notes

This requirement restates an existing rule of the model for the new files. Status lives in an
external tool.
