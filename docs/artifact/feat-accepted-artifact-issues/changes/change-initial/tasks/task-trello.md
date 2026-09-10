# task-trello: Add the Trello adapter

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, req-portable-links, spec-trello
**Context:** context-factory

## Goal

Synchronize artifact cards, lists, description metadata, and parent links through the Trello API.

## Steps

1. Check the configured board and lists.
2. Create or update cards by artifact identity.
3. Set the configured list for each new card.
4. Add description metadata and child checklist links.
5. Archive withdrawn artifact cards.

## Check

Run adapter checks with recorded Trello API responses and requests.
