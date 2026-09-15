# spec-coordination-protocol: Control one change

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The canonical artifact-master role must control one artifact-driven change. It must own all
expert spawning and coordination. A content expert must not spawn or directly task another
expert.

The artifact master must use `Plan-Pn then Build-Pn` with these routes:

| Work | Content owner | Coordination action |
| --- | --- | --- |
| Phase 1 | Requirement expert | Spawn the expert and give it the approved phase input. |
| Phases 2 and 3 | Solution expert | Spawn the expert and give it the approved phase input. |
| Phase 2 feasibility review | Applicable implementation expert | Route the unchanged contract and return constraints without edits. |
| Phase 4 task | Applicable implementation expert | Select the owner and start the task in its approved work batch. |
| Phase 5 readiness gate | Solution expert | Request readiness confirmation only. |
| Phase 5 copy | Artifact release expert | Start the copy only after readiness is `true`. |

The artifact master must not write phase content. It must keep the `coordinate-plan` in chat only.
The solution expert alone must write the phase 3 `execution-plan`.

For an uncovered component, the solution expert must give owner advice to the artifact master.
The artifact master must select the owner. The solution expert must not spawn that owner. The
artifact master must use the master-selected owner for the applicable review or phase 4 task.

The artifact master must keep each phase output in one commit. A later phase must not start before
the prior phase commit exists. Phase 4 has no Plan-P4.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Coordination moved | Artifact master | Content experts | Change, coordination owner, and no-subagent boundary. |
| Contract written | Solution expert | Artifact master | Review identifier, complete contract, context, aggregate, and component. |
| Feasibility routed | Artifact master | Implementation expert | The unchanged Contract written payload and requested constraint fields. |
| Constraint returned | Implementation expert | Artifact master, then solution expert | Review identifier, constraint, evidence, affected item, and responsible owner. |
| Owner selected | Artifact master | Solution expert and implementation expert | Component, selected owner, advice, and selection reason. |
| Work batched | Artifact master | Implementation experts | Ordered batches, owners, dependencies, and commit boundary. |
| Release routed | Artifact master | Artifact release expert | Phase 5 input, source commit, and readiness confirmation. |

### Data model

Each expert request must use this coordination envelope:

| Field | Rule |
| --- | --- |
| `change` | It identifies one change. |
| `phase` | It identifies one phase or the phase 2 feasibility review. |
| `source-owner` | It identifies the content owner that supplied the input. |
| `target-owner` | It identifies the expert that receives the request. |
| `component` | It identifies the affected component, when applicable. |
| `input` | It contains the approved phase input or unchanged review payload. |
| `expected-output` | It identifies the output that the target owner can return. |
| `commit-boundary` | It identifies the one phase commit. |

The `coordinate-plan` must contain the change, version change, expert order, commit boundaries,
phase inputs, and phase outputs. It must not occur in `tasks/`.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact master owns all expert spawning and does not own phase content. |
| Upstream to downstream | None. `context-factory` is the only bounded context. Expert routes stay inside this context. |

## Description

This contract moves coordination calls from content experts to the artifact master. The content
owner does not change. The artifact master moves the payload between content owners without a
content change.

## Constraint resolutions

[`adr-master-coordination`](../decisions/adr-master-coordination.md) records the master route,
owner-selection, mirror, and local-role resolutions. [`adr-opencode-coordination-permissions`](../decisions/adr-opencode-coordination-permissions.md)
records the OpenCode route constraints.

## Errors

- If the prior phase input or its commit is absent, stop and request the missing input.
- If a content expert attempts to spawn another expert, stop that route and return it to the artifact master.
- If an implementation expert does not cover a component, request owner advice from the solution expert.
- If phase 3 has invalid dependency data, do not start phase 4.
- If readiness is not `true`, do not route the phase 5 copy.
