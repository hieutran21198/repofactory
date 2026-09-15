# req-accepted-only: Synchronize only accepted artifacts

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must make project issues only from artifacts on the default branch after a pull
request merges.

## Acceptance criteria

- Given an artifact pull request, when the pull request merges, then CI synchronizes its artifacts.
- Given an artifact pull request, when it closes without merge, then CI makes no project issue.
- Given a non-artifact pull request, when it merges, then CI makes no project issue.

## Notes

Git remains the acceptance record for each artifact.
