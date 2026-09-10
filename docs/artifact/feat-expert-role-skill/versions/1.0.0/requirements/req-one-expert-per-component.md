# req-one-expert-per-component: Say when a project needs an implementation expert

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The expert role skill must say when a project needs an implementation expert: one expert for
each component. When the project uses domain-driven design, the skill must say: one expert for
each bounded context.

## Acceptance criteria

- Given the expert role skill, when an agent reads it, then the skill says that a project has one implementation expert for each component.
- Given a project that uses domain-driven design, when an agent reads the skill, then the skill says that the project has one implementation expert for each bounded context.
- Given a component that already has an implementation expert, when an agent reads the skill, then the skill tells the agent not to add a second expert for that component.

## Notes

The design guide of the project maps one bounded context to one component. In a project that
uses domain-driven design, the two rules are the same rule: one expert for each bounded context
is one expert for each component.
