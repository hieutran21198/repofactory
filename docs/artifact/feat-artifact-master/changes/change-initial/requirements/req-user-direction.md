# req-user-direction: Help the user direct the work

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must show each choice or action that it needs from the user. For each phase
plan, it must request explicit approval before the phase build starts. It must include the scope,
expected files, owner, and acceptance checks in that request.

## Acceptance criteria

- Given a choice that changes the work, when the artifact master needs an answer, then it shows the choice and its effect.
- Given an action that the user must do, when the artifact master reports it, then it states the action and its reason.
- Given a phase with a phase plan, when the artifact master requests approval, then it includes the scope, files, owner, and acceptance checks.
- Given a phase plan without approval, when the artifact master controls the change, then it does not start that phase build.

## Notes

Phase 4 has no phase plan. It starts from the implementation plan that the user approved in phase 3.
