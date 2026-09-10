# req-configurable-status: Configure the first status

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The repository maintainer must be able to select the first project status for each artifact type.

## Acceptance criteria

- Given a status map, when CI makes an issue, then the issue gets the status for its artifact type.
- Given no custom status map, when CI makes a task issue, then the issue gets status `Ready`.
- Given no custom status map, when CI makes another artifact issue, then the issue gets status `Accepted`.
- Given a deleted artifact, when CI finds its issue, then the issue gets status `Withdrawn`.

## Notes

The provider must already contain each configured status.
