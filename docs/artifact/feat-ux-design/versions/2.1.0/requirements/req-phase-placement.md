# req-phase-placement: Keep UX Design inside the Specs and ADRs phase

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

UX Design must belong to the Specs and ADRs phase. The workflow must add no separate phase for
UX Design.

## Acceptance criteria

- Given UX Design enabled, when the artifact master runs the five phases, then the phase count stays at five.
- Given UX Design enabled, when the Specs and ADRs phase runs, then the phase produces the Design artifact with the specifications and the decisions.
- Given UX Design disabled, when the Specs and ADRs phase runs, then the phase produces no Design artifact.

## Notes

The five artifact-driven phases do not change. Later phases read the Design artifact as part of
the Specs and ADRs phase output.
