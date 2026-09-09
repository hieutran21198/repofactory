# task-check-trello-free: Check the Trello Free life cycle

**Plan:** [Implementation plan](README.md)
**Covers:** req-support-trello-free, spec-trello-free
**Context:** context-factory

## Goal

Make the live-provider check verify the Trello Free contract.

## Steps

1. Stop creating or checking Custom Fields during setup.
2. Validate the description metadata and hidden marker.
3. Validate card identity, names, lists, rename behavior, links, and parent checklists.
4. Run Trello setup again to reuse the current board.
5. Run the create, rerun, update, rename, withdraw, and cleanup life cycle.

## Check

Run the complete Trello end-to-end check with a token that has read and write scopes.
