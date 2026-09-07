# req-context-boundary-rule: Map a bounded context to a component

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The design guide must give one rule that maps a bounded context to a component of the
repository architecture.

## Acceptance criteria

- Given the design guide, when a user reads the boundary rule, then it says which component type implements one bounded context.
- Given the design guide, when a user reads the boundary rule, then it says what an application and a library can hold.
- Given a bounded context artifact, when a user reads it, then it names the component that implements the context.

## Notes

The repository architecture defines the component types `apps/`, `services/`, `libs/`,
`deployment/`, and `e2e/`.
