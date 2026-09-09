# Specifications: Split Trello boards

**Change:** [Split Trello planning and implementation boards](../README.md)

## Solution

Keep `board-id` as the planning board. Add an optional `implementation-board-id`. Route cards by
artifact kind and keep one card identity across both boards.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-split-trello-boards](spec-split-trello-boards.md) | Route and migrate Trello cards across two boards. | req-split-trello-boards |
