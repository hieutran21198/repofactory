# Change: Add live provider end-to-end checks

**Feature:** [Accepted artifact issues](../../README.md)

## Reason

The existing checks do not use the GitHub Projects API or the Trello API. A repository maintainer
needs a repeatable check of the generated workflow with the two live providers.

## Effect

This change adds an end-to-end check component. The component uses separate test repositories and
separate provider resources. It does not change the generated integration contract.

## Artifacts

- [Specifications](specifications/README.md)
- [Decisions](decisions/adr-persistent-sandboxes.md)
- [Implementation plan](tasks/README.md)
