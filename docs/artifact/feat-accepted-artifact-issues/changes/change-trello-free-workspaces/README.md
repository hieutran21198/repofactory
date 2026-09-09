# Change: Support Trello Free workspaces

**Feature:** [Accepted artifact issues](../../README.md)
**Type:** Requirements

## Reason

The Trello adapter requires Custom Fields. Trello Free workspaces do not supply this feature.
Repository maintainers need artifact issue synchronization without a paid Trello plan.

## Effect

The Trello adapter uses card descriptions as its metadata store. It does not create, read, update,
or delete Custom Fields.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
