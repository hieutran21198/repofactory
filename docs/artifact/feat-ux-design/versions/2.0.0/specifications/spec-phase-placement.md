# spec-phase-placement: Keep UX Design in phase 2

**Master:** [Specifications](README.md)
**Covers:** req-phase-placement
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The artifact-driven workflow must keep these five phases:

1. Requirements.
2. Specifications, also named the Specs and ADRs phase.
3. Plan.
4. Implementation.
5. Version.

When UX Design is on, phase 2 must produce Specs, applicable ADRs, and the Design artifact. The
workflow must add no UX Design phase. Phase 3 and phase 4 must read the Design artifact when their
work changes a user interface.

The factory must add phase rules as optional role chapters. `mkRole` must append the Domain-Driven
Design chapter first when applicable. It must append the UX Design chapter after that chapter.
The factory must not edit a base role body.

The optional artifact-master chapter must route and join Design work. The optional solution-expert
chapter must define the parallel solution and design work. The optional artifact-release-expert
chapter must add `design/` to step 3 of the phase 5 copy.

Phase 5 must copy the current `design/README.md` as part of the version copy. It needs no new
option. Phase 5 must not run a design step or edit the Design artifact.

When UX Design is off, no phase must request, read, write, or copy a Design artifact.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Requirements accepted | Requirement expert | Artifact master, solution expert, designer expert | The phase 1 commit and the accepted Requirements paths. |
| Design completed | Designer expert | Artifact master | The Design artifact path and the covered change. |
| Phase 2 output joined | Artifact master | Phase 3 | Specs, ADRs when applicable, and Design when UX Design is on. |

### Data model

| Item | Value when UX Design is off | Value when UX Design is on |
| --- | --- | --- |
| Phase count | `5` | `5` |
| Phase 2 owners | Solution expert | Solution expert and designer expert |
| Phase 2 feature artifacts | Specs and applicable ADRs | Specs, applicable ADRs, and Design |
| Design path in a change | absent | `changes/change-<name>/design/README.md` |
| Design path in a version | absent | `versions/<version>/design/README.md` |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | UX Design changes the output of phase 2, but it does not change the phase count. |
| Upstream to downstream | None. All phase rules stay in `context-factory`. |
| Component | `services/factory` |

## Description

The Design artifact is a peer of Specs and ADRs in phase 2. Its copy in a version gives later
changes the current design state.

## Errors

- If coordination creates a sixth phase, stop the change.
- If UX Design is on and phase 2 has no Design artifact, do not commit phase 2.
- If UX Design is off and phase 2 has a Design artifact, fail the unchanged-workflow check.
