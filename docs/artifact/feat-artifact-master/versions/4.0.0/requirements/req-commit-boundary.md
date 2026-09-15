# req-commit-boundary: Keep one commit boundary for each phase

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must end each phase build with one commit for that phase. It must not start
the next phase before this commit exists.

## Acceptance criteria

- Given a completed phase build, when the artifact master ends the phase, then one commit contains that phase output.
- Given a phase without its commit, when the artifact master controls the change, then it does not start the next phase.
- Given a phase commit, when the next phase starts, then that commit supplies the artifact input.

## Notes

The commit boundary keeps the input of the next phase stable.
