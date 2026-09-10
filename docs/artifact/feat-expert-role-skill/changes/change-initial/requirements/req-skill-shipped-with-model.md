# req-skill-shipped-with-model: Ship the skill with the artifact-driven model

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

A project that selects the artifact-driven documentation model must get the expert role skill
in the skill folder of each harness in use.

## Acceptance criteria

- Given a project that selects the artifact-driven documentation model and one harness, when the project enters its shell, then the skill folder of that harness contains the expert role skill.
- Given a project that selects the artifact-driven documentation model and two or more harnesses, when the project enters its shell, then the skill folder of each harness contains the same expert role skill.
- Given a project that does not select the artifact-driven documentation model, when the project enters its shell, then no harness contains the expert role skill.

## Notes

The skill belongs to the artifact-driven documentation model because the implementation expert
owns phase 4 of that model. A project without the model has no phase 4 to own.
