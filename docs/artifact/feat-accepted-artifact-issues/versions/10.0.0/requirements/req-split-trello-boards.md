# req-split-trello-boards: Separate planning and implementation

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must optionally route Trello implementation artifacts to a separate board.

## Acceptance criteria

- Given no implementation board, when synchronization runs, then all cards stay on the primary board.
- Given an implementation board, when synchronization runs, then plans and tasks use that board.
- Given an implementation board, when synchronization runs, then all other artifacts use the planning board.
- Given an existing implementation card on the planning board, then synchronization moves it and keeps its identity.
- Given a cross-board parent, then descriptions and `Children` checklists keep the hierarchy.
