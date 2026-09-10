# task-check-trello-board-id: Check board ID resolution

**Master:** [Implementation plan](README.md)
**Covers:** spec-resolve-trello-board-id
**Context:** context-factory

## Goal

Test label creation with a configured board short link.

## Steps

1. Add a fixture that returns an internal board ID for a short link.
2. Run preflight with a missing managed label.
3. Check that the label create request uses the internal board ID.

## Check

Run the synchronization unit tests and the artifact-driven composition evaluation.
