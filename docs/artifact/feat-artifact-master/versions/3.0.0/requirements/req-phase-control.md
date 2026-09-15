# req-phase-control: Control each phase

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must control one artifact-driven change through the five phases in order. It
must plan and build one phase before it starts the next phase. A phase must use only the committed
output of the prior phase as its artifact input. Phase 1 uses the business need as its input.

## Acceptance criteria

- Given a new change, when the artifact master starts phase 1, then it uses the business need as the input.
- Given a committed phase, when the artifact master starts the next phase, then it uses the committed output as the artifact input.
- Given an incomplete phase, when the artifact master controls the change, then it does not start a later phase.

## Notes

Phase 4 has no separate phase plan. Its input is the approved implementation plan from phase 3.
