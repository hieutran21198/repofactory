# Change: Initial

**Feature:** [Expert role skill](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

A software team that uses the repository factory in its own project needs implementation
experts. The factory ships the requirement expert and the solution expert. It does not ship an
implementation expert, because an implementation expert knows one component of one project.
The solution expert of the project gives the specifications and the tasks of each component to
the implementation expert of that component.

Today, a coding agent that adds an implementation expert to a project must open the factory
repository. Only the factory repository gives the shape of a role body and the fields of a role
declaration. Only the factory repository gives the phase contract of an implementation expert.
This breaks the promise that a generated repository is self-contained.

A project that selects the artifact-driven documentation model must receive a skill. With the
skill, a coding agent sets up an implementation expert role for one component. The agent must do
this from the files in the project only. The solution expert must point to this skill when no
implementation expert covers a component.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
