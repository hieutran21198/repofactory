# Change: Select a provider during setup

**Feature:** [Accepted artifact issues](../../README.md)

## Reason

The setup command always needs credentials for GitHub Projects and Trello. A maintainer can have
credentials for only one provider and cannot set up its end-to-end check.

## Effect

This change lets a maintainer select one provider during setup. The default setup behavior still
sets up both providers.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
