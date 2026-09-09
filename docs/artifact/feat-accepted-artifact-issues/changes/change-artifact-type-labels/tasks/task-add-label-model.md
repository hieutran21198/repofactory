# task-add-label-model: Add the managed label model

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-type-labels, spec-artifact-type-labels
**Context:** context-factory

## Goal

Define the common label names, ownership rule, and provider color maps.

## Steps

1. Add the `artifact:` label prefix.
2. Map each supported artifact kind to one label name.
3. Add a GitHub hexadecimal color for each kind.
4. Add a Trello named color for each kind.
5. Add unit tests for the complete and unique mapping.

## Check

Run the synchronizer unit suite.
