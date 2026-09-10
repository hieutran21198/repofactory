# Change: Initial

**Feature:** [Single repository architecture](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

Project teams with one deliverable need a repository layout that agents can follow without the
component-type split of the multiple repositories architecture. The option `repo-arch.use`
accepts the value `single`, but the generator writes no file for it. The generated project must
give one location for the code, one for the tests of the complete component, one for the
deployment configuration, and one for the project knowledge.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
