# Change: Initial

**Feature:** [Artifact versions](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

The AI agents and the people who work with feature artifacts need the current state of a feature
in one place. Today the model keeps the first build of a feature in root folders and each later
change in a change folder. The wiki tells the author to update the root artifacts after a change,
but nothing enforces it, and it is not done. A reader must read the root folders and each change
folder and merge them. That costs context and produces mistakes. The maintainers of the model need
one layout that keeps each change and gives the full state of the feature at each version.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
