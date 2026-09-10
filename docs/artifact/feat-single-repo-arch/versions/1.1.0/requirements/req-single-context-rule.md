# req-single-context-rule: Give the home of a bounded context

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The design guide, the bounded context template, the phase-mapping page, and the DDD role chapter
must give one rule that maps a bounded context to a directory of the single repository
architecture. The rule for the multiple repositories architecture must not change.

## Acceptance criteria

- Given the design guide, when a user reads the section that gives where a context lives, then it
  gives one rule for the multiple repositories architecture and one rule for the single
  repository architecture.
- Given the bounded context template, when a user reads the `**Component:**` line, then it
  gives the value shape for both architectures.
- Given the phase-mapping page, when a user reads the implementation phase, then it names the
  directory of the context for both architectures.
- Given the DDD chapter of the solution expert, when a user reads its rules, then it gives the
  home of a bounded context for both architectures.

## Notes

The rule for the multiple repositories architecture is in
`docs/artifact/feat-ddd-design/decisions/adr-context-boundary.md`. This feature adds a rule; it
does not change that decision.
