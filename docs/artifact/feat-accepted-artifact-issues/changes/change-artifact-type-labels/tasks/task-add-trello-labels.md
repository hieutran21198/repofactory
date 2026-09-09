# task-add-trello-labels: Add Trello type labels

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-type-labels, spec-artifact-type-labels
**Context:** context-factory

## Goal

Show the artifact type on each Trello card without a Power-Up.

## Steps

1. Read board labels during preflight.
2. Create missing managed labels with their configured colors.
3. Include label IDs when the adapter reads managed cards.
4. Apply the current type label during each upsert.
5. Remove obsolete managed labels and preserve user labels.
6. Add tests for create, update, rename, and withdraw operations.

## Check

Use recorded Trello API requests to verify label creation and card updates.
