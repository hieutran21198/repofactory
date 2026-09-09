# task-add-split-board-configuration: Add split-board configuration

**Plan:** [Implementation plan](README.md)
**Covers:** req-split-trello-boards, spec-split-trello-boards
**Context:** context-factory

## Goal

Add the optional implementation board to the provider and generated configuration.

## Steps

1. Add `implementation-board-id` with an empty default.
2. Reject two equal configured board IDs.
3. Render the implementation board ID in the synchronizer configuration.
4. Add Nix evaluation checks.

## Check

Run the artifact-driven composition module evaluation.
