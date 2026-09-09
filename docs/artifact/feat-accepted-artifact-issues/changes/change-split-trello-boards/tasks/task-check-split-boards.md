# task-check-split-boards: Check split-board behavior

**Plan:** [Implementation plan](README.md)
**Covers:** req-split-trello-boards, spec-split-trello-boards
**Context:** context-factory

## Goal

Verify single-board and split-board Trello life cycles.

## Steps

1. Extend E2E setup state for the optional board.
2. Inspect cards across both configured boards.
3. Verify routing, status, labels, identity, and hierarchy.
4. Update generated setup documentation and master artifacts.
5. Run the Python and Nix checks.

## Check

Run the single-board and split-board E2E scenarios.
