# Implementation plan: Split Trello boards

**Change:** [Split Trello planning and implementation boards](../README.md)

## Order

| Order | Task | Depends on |
| --- | --- | --- |
| 1 | [Add split-board configuration](task-add-split-board-configuration.md) | - |
| 2 | [Route and migrate cards](task-route-trello-cards.md) | 1 |
| 3 | [Check split-board behavior](task-check-split-boards.md) | 2 |

## Completion

- Single-board behavior stays compatible.
- Split-board routing and automatic migration pass adapter tests.
- Nix evaluation and local E2E tests pass.
