# req-solution-expert-hand-off: Point the solution expert to the skill

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The solution expert role that the factory ships must point to the expert role skill when no
implementation expert covers a component. Before the solution expert writes the specifications
and the tasks of that component itself, it must offer to set up the implementation expert with
the skill.

## Acceptance criteria

- Given the shipped solution expert role, when an agent reads the "Mixture of experts" section, then the section names the expert role skill.
- Given a component that no implementation expert covers, when the solution expert works on that component, then the solution expert tells the user that the skill can set up an implementation expert for it.
- Given a component that no implementation expert covers and a user who does not want a new expert, when the solution expert works on that component, then the solution expert writes the part itself and says so in its report.
- Given a project that does not select the artifact-driven documentation model, when the project enters its shell, then the project has no solution expert role and no expert role skill.

## Notes

The requirement expert role does not change.
