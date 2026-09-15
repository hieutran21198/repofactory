# req-support-trello-free: Synchronize with Trello Free

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must synchronize accepted artifacts to Trello without the Custom Fields feature.

## Acceptance criteria

- Given a Trello board without Custom Fields, when synchronization starts, then preflight succeeds.
- Given an artifact, when synchronization creates or updates its card, then no Custom Fields API call occurs.
- Given an artifact card, when a maintainer reads its description, then the description shows its path and type.
- Given a child artifact card, when a maintainer reads its description, then the description shows its parent path.
- Given an artifact card, when synchronization finds it, then the hidden artifact marker identifies the card.
- Given a paid board with existing Custom Fields, when synchronization runs, then it does not change those fields.
