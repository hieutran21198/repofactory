# task-resolve-trello-board-id: Resolve the board ID

**Master:** [Implementation plan](README.md)
**Covers:** spec-resolve-trello-board-id
**Context:** context-factory

## Goal

Resolve each configured Trello board reference before managed label creation.

## Steps

1. Read the board ID during adapter preflight.
2. Save the returned ID in the board context.
3. Use the saved ID in a managed label create request.

## Check

Run the synchronization unit tests.
