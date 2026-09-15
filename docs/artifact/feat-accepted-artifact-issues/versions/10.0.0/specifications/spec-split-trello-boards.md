# spec-split-trello-boards: Route Trello cards

**Master:** [Specifications](README.md)
**Covers:** req-split-trello-boards
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Configuration contract

`board-id` identifies the planning board. `implementation-board-id` identifies an optional second
board. The default is empty. Two configured board IDs must be different.

## Routing contract

The implementation board contains `implementation-plan` and `task` cards. The planning board
contains all other artifact kinds. Each board requires only its used statuses and `Withdrawn`.

The adapter reads cards from both boards. One artifact marker must occur only once across them.

## Migration contract

When a card is on the wrong board, upsert moves it to the correct board and status list. The move
keeps the card ID. The adapter then applies the destination board type label.

Descriptions and `Children` checklists use stable short URLs and can link across boards.

## Errors

- Stop if a configured board is inaccessible.
- Stop if a board does not contain a required status list.
- Stop if two cards have the same marker across the boards.
- Stop if Trello rejects a card move.
