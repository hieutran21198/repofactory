# Specifications: Artifact master

**Change:** [Governance](../../../changes/change-governance/README.md)

## Solution

The `services/factory` component supplies the governance contracts to each generated repository.
The artifact master routes phase 5 to the artifact release expert. The solution expert confirms
release readiness and does not copy the version.

Phase 2 starts with a contract. The solution expert owns the specification and the final
decision. The implementation expert returns feasibility constraints without authoring the
specification. Each final specification includes its resolved constraints.

The requirement expert and the solution expert use an option interview when they find a
correction or a better path. Phase 4 uses the phase 3 dependencies and each `can-parallel`
answer to make ordered work batches. Independent tasks run in parallel. One commit contains the
phase 4 output.

The Repository blueprint aggregate stays a Domain model. Its invariants include the role routes,
the contract review, the option interview, and the parallel work rules. The context map has one
context. Thus, this change adds no relationship and no shared code in `libs/`.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-coordination-protocol](spec-coordination-protocol.md) | Control, route, and commit one change phase by phase. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary |
| [spec-phase-messages](spec-phase-messages.md) | Give the user phase messages and option interviews with required fields. | req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |
| [spec-harness-delivery](spec-harness-delivery.md) | Supply the role behavior to each selected harness. | req-harness-delivery |
| [spec-verification-contract](spec-verification-contract.md) | Check the roles, skills, pages, and rendered harness contracts. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation |
| [spec-moex-page](spec-moex-page.md) | Define the mixture-of-experts wiki page and its required explanation. | req-moex-explanation |
| [spec-moex-delivery](spec-moex-delivery.md) | Copy the wiki page and its index link to each generated repository layout. | req-moex-nix-delivery |
| [spec-release-role](spec-release-role.md) | Define the phase 5 interface of the artifact release expert. | req-release-role, req-expert-routing |
| [spec-contract-driven](spec-contract-driven.md) | Define the contract-first phase 2 interface and feasibility review. | req-contract-driven-spec |
| [spec-interactive-recommend](spec-interactive-recommend.md) | Define the option interview and its approval gate. | req-interactive-recommend |
| [spec-parallel-implementation](spec-parallel-implementation.md) | Define task dependencies and parallel phase 4 work. | req-parallel-implementation |

## Decisions

- [adr-canonical-role-source](../decisions/adr-canonical-role-source.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
- [adr-moex-page-variants](../decisions/adr-moex-page-variants.md)
- [adr-release-routing](../decisions/adr-release-routing.md)
- [adr-contract-first](../decisions/adr-contract-first.md)
