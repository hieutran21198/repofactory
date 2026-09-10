# req-portable-links: Keep artifact links portable

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must keep provider identifiers out of artifact files. Each issue must link to the
accepted artifact, merge commit, and merged pull request.

## Acceptance criteria

- Given a created issue, when a reader opens it, then the reader can open the accepted artifact.
- Given a created issue, when a reader opens it, then the reader can open its merge commit and pull request.
- Given an accepted artifact, when CI synchronizes it, then CI does not change the artifact content.
- Given one artifact and provider, when CI runs again, then CI updates the same issue.

## Notes

CI adds the issue URLs to the merged pull request for reverse navigation.
