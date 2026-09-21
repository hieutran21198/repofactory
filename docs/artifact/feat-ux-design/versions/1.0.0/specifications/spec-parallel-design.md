# spec-parallel-design: Run parallel phase 2 work

**Master:** [Specifications](README.md)
**Covers:** req-parallel-workflow
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

When UX Design is on, the artifact master must start solution work and design work from the same
accepted Requirements. The solution expert must write Specs and applicable ADRs. The designer
expert must write the Design artifact.

The factory must author this sequence in conditional artifact-master and solution-expert role
chapters. It must append the chapters only when UX Design is on. It must not add a Nix option for
the sequence. It must not edit the base role bodies.

The work must use this sequence:

1. The artifact master gives the accepted Requirements to both experts.
2. The solution expert writes the contracts and draft ADRs.
3. The designer expert starts Design from the Requirements and the current artifacts.
4. The artifact master sends Reconcile Design with the final Spec and ADR drafts.
5. The designer expert handles Reconcile Design with those constraints.
6. The artifact master joins both outputs before the phase 2 commit.

Steps 2 and 3 can run in parallel. Step 4 depends on step 2. Step 5 depends on steps 3 and 4. The
phase 2 commit depends on the completed solution and design outputs.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Requirements accepted | Requirement expert | Solution expert, designer expert | The phase 1 commit and Requirement paths. |
| Contract written | Solution expert | Artifact master | The feasibility-review payload. |
| Specifications and decisions written | Solution expert | Artifact master, designer expert | The final draft paths and each controlling constraint. |
| Design completed | Designer expert | Artifact master | The Design path and the controlling artifact references. |
| Phase 2 output joined | Artifact master | User | The solution output, the design output, and one commit boundary. |

### Data model

| Work item | Owner | Starts after | Completes before |
| --- | --- | --- | --- |
| Specs and ADRs | Solution expert | Requirements accepted | Phase 2 output joined |
| Design draft | Designer expert | Requirements accepted | Design reconciliation |
| Design reconciliation | Designer expert | Final Spec and ADR drafts exist | Phase 2 output joined |
| Phase 2 join | Artifact master | Both owners complete | Phase 2 commit |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Phase 2 commits one joined output in which Design follows the Specs and ADRs. |
| Upstream to downstream | None. The parallel owners work inside `context-factory`. |
| Component | `services/factory` |

## Description

The contract permits concurrent discovery and design. The final reconciliation keeps the Specs
and ADRs as constraints without moving Design to a separate phase.

## Errors

- If one output is absent, do not join or commit phase 2.
- If Design does not follow a final Spec or ADR, return Design to the designer expert.
- If an expert edits the other expert's artifact, restore the ownership boundary.
