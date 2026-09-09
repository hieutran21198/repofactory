# task-route-trello-cards: Route and migrate cards

**Plan:** [Implementation plan](README.md)
**Covers:** req-split-trello-boards, spec-split-trello-boards
**Context:** context-factory

## Goal

Route cards by artifact kind and move existing cards to the correct board.

## Steps

1. Load lists, labels, and cards for each configured board.
2. Require only the statuses used on each board.
3. Select the destination board from the artifact kind.
4. Move a card when its current board differs from its destination.
5. Reconcile the managed label after a move.
6. Preserve cross-board parent and child links.

## Check

Run adapter tests for routing, migration, identity, labels, and duplicate markers.
