# req-resolve-trello-board-id: Resolve the board ID

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The Trello adapter must resolve each configured board reference and use the returned internal board
ID when it creates a missing managed label.

## Acceptance criteria

- Given a configured board short link and no managed labels, when synchronization runs, then each label request uses the returned board ID.
- Given a configured internal board ID, when synchronization runs, then each label request uses that board ID.
