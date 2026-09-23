# req-parallel-workflow: Work in parallel under Specs and ADRs constraints

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The designer expert must work in parallel with the solution expert in the Specs and ADRs phase.
The designer expert must use the Requirements baseline as its base. It must treat the Specs and
the ADRs as constraints on the design.

## Acceptance criteria

- Given UX Design enabled, when the Specs and ADRs phase runs, then the solution expert writes Specs and ADRs while the designer expert writes the Design artifact.
- Given the accepted Requirements, when the designer expert designs, then the design covers the Requirements baseline.
- Given a current Spec or a current ADR, when the designer expert designs, then the design follows that Spec or ADR as a constraint.

## Notes

The workflow order stays Requirements, then Specs with ADRs with Design, then the later phases.
The artifact master routes the designer expert in the same phase as the solution expert.
