# req-phase-handoff: Give a complete phase handoff

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

After each phase build, the artifact master must give a phase handoff. The handoff must list the
written files, checks, commit, key decisions, open items, and the input for the next phase. It must
also state the next user action.

## Acceptance criteria

- Given a completed phase build, when the user reads the handoff, then the user can identify the written files, checks, and commit.
- Given a completed phase build, when the user reads the handoff, then the user can identify key decisions and open items.
- Given a next phase, when the user reads the handoff, then the user can identify its input and the next user action.
- Given no key decisions or open items, when the artifact master gives the handoff, then it states that there are none.

## Notes

The handoff is the last user message of the phase build.
