# req-concise-communication: Keep communication concise

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must keep each phase message short and useful. It must give enough context for
the user to act or check the result. It must not repeat unchanged information unless the user
needs it for the current action.

## Acceptance criteria

- Given a phase message, when the user reads it, then each part helps the user understand, decide, act, or check.
- Given information from an earlier message, when it does not affect the current action, then the artifact master does not repeat it.
- Given required context from an earlier message, when the user needs it for the current action, then the artifact master includes it.

## Notes

Concise communication does not remove required phase information.
