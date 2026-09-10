# req-artifact-type-labels: Show the artifact type

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must add one managed artifact type label to each GitHub issue and Trello card.

## Acceptance criteria

- Given an artifact, when synchronization creates its item, then the item has its type label.
- Given an existing item, when synchronization runs, then the item has exactly one managed type label.
- Given an unrelated user label, when synchronization runs, then the user label stays on the item.
- Given a withdrawn artifact, when synchronization archives its item, then its type label stays on the item.
- Given either provider, when labels are unavailable, then synchronization reports the provider error.
