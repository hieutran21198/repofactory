# Change: Resolve Trello board IDs before label creation

**Feature:** [Accepted artifact issues](../../README.md)
**From:** 7.0.0
**To:** 8.0.0
**Type:** Requirements

## Reason

Trello accepts a board short link when the adapter reads board data. It rejects that short link as
the `idBoard` value when the adapter creates a missing managed label.

## Effect

The Trello adapter resolves each configured board reference to its internal board ID before it
creates a managed label.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
