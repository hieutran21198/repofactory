# spec-coordination-protocol: Control one change

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The canonical artifact-master role must control one artifact-driven change. It must delegate
phase content to the expert that owns the phase. It must keep each phase output in one commit.

The role must contain a `Plan-Pn then Build-Pn` procedure with these rules:

- Plan-P1 reads the business need or the change reason.
- Plan-P2, Plan-P3, and Plan-P5 read only the committed output of the prior phase.
- A plan is read-only. It stops for explicit user approval before its build starts.
- Phase 1 routes to the requirement expert.
- Phases 2 and 3 route to the solution expert.
- Phase 5 routes to the artifact release expert.
- The solution expert confirms phase 5 readiness only. It does not copy the version.
- Phase 4 routes each component task to its implementation expert.
- For an uncovered phase 4 component, the solution expert helps select an owner.
- Phase 4 uses the approved dependencies and each `can-parallel` answer from phase 3.
- The artifact master does not write phase content. It checks the work of each phase owner.
- Each build writes only its phase output and ends with one commit for that phase.
- A later phase does not start before the prior phase commit exists.
- Phase 4 has no Plan-P4. It starts from the implementation plan approved in phase 3.

The role must keep a `coordinate-plan` in the chat only. It must not put the coordinate-plan in
`tasks/`. The solution expert alone writes the phase 3 execution plan.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Release routed | Artifact master | Artifact release expert | Phase 5 input, source commit, and readiness confirmation. |
| Work sequenced | Solution expert | Artifact master | Task dependencies, ordered batches, and each `can-parallel` answer. |

### Data model

The coordinate-plan must contain this data in chat:

| Field | Rule |
| --- | --- |
| Change | It identifies one change. |
| Version change | It gives the `From`, `To`, and `Type` values. |
| Expert order | It gives the owner of each applicable phase. |
| Commit boundaries | It gives one boundary for each phase. |
| Phase input | It identifies the committed input for each phase. |
| Phase output | It identifies the permitted output for each phase. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact master routes one phase at a time and does not own phase content. |
| Upstream to downstream | None. `context-factory` is the only bounded context. Expert routes stay inside its process boundary. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| One canonical artifact-master role body supplies the coordination contract. | `services/factory` implementation owner |
| The artifact-master skill must stay thin and must use the rendered role as its source. | `services/factory` implementation owner |
| The Nix composition must change the built-in route without changing the five phases. | `services/factory` implementation owner |
| Project-specific implementation experts remain outside the built-in role set. | Solution expert |
| All phase 4 work must end at one commit boundary. | Artifact master |

`adr-release-routing` and `adr-contract-first` record the related repository constraints and
their owners.

## Errors

- If the prior phase input or its commit is absent, stop and request the missing input.
- If a content choice needs a decision, identify the phase owner that needs the user answer.
- If no implementation expert covers a phase 4 component, route owner selection to the solution expert.
- If the solution expert has not confirmed readiness, do not route phase 5.
- If phase 3 has no valid dependency data, do not start phase 4.
