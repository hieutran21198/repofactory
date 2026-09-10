# req-self-contained-guidance: Keep the guidance in the project

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

An agent that follows the expert role skill must set up an implementation expert role with the
files in the project only. The skill must not send the agent to the factory repository or to any
other location outside the project.

## Acceptance criteria

- Given the expert role skill, when an agent reads it, then each file that the skill tells the agent to read is in the project.
- Given the expert role skill, when an agent reads it, then the skill does not tell the agent to fetch, clone, or open the factory repository.
- Given a project with the skill and no network access to the factory repository, when an agent follows the skill, then the agent writes a role body and a role declaration that render as a role file in each harness in use.

## Notes

This requirement is the reason for the feature. Today the agent must open the factory repository.
Only the factory repository gives the shape of a role body, the fields of a role declaration, and
the phase contract of an implementation expert.
