# req-harness-delivery: Give the behavior to each harness

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

Each harness in use must receive the artifact master. The artifact master must give the same phase
control and user communication in each harness.

## Acceptance criteria

- Given a project with one harness, when the project supplies the artifact master, then that harness has the artifact master.
- Given a project with two or more harnesses, when each artifact master controls the same change, then each one gives the required behavior.
- Given an artifact master in a harness, when it gives phase messages, then the messages meet the user communication requirements.

## Notes

A harness can supply the artifact master as a role, a skill, or both.
