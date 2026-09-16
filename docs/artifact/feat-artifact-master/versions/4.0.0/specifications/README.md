# Specifications: Artifact master

**Change:** [Master coordination](../../../changes/change-master-coordination/README.md)

## Solution

The `services/factory` component supplies one coordination contract to each generated
repository. The artifact master owns all expert spawning and coordination. It routes each phase
to its content owner. The solution expert owns the content of phases 2 and 3. It also owns the
phase 5 readiness gate. It calls no subagent.

In phase 2, the solution expert writes each contract first. It sends each feasibility-review
request to the artifact master. The artifact master routes the unchanged contract to the
applicable implementation expert. The implementation expert returns constraints only. The
artifact master returns the constraints to the solution expert for resolution.

In phase 4, the artifact master selects each task owner. It makes ordered work batches from the
approved dependencies and each `can-parallel` answer. It starts independent tasks in parallel.
All phase 4 output stays in one commit.

The factory gives all factory-rendered OpenCode roles declared coordination permissions. The
artifact master has `mode = "all"` and `permission.task = "allow"`. Each factory-rendered content
expert has `mode = "subagent"` and `permission.task = "deny"`. The global OpenCode settings hold
each task permission. The subagent depth is 1. The user must select the artifact master as the
primary OpenCode agent before coordination starts.

The factory renders the same instruction body for each role in each selected harness. Harness
frontmatter can differ. The canonical mixture-of-experts page and its two repository-layout
mirrors change together. Each tracked project-local role body gives the constraints-only rule.
The ignored `devenv.local.nix` descriptions are local-only and outside the versioned contract.

The Repository blueprint aggregate keeps the Domain model pattern. Its invariants include one
coordination owner, master-routed feasibility review, declared role permissions, and phase 4
batching. The context map has one context. This change adds no context relationship and no shared
code.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-coordination-protocol](spec-coordination-protocol.md) | Control all expert spawning and route one change phase by phase. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary |
| [spec-phase-messages](spec-phase-messages.md) | Give the user phase messages and option interviews with required fields. | req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |
| [spec-harness-delivery](spec-harness-delivery.md) | Supply the same role body and declared coordinator permissions to each selected harness. | req-harness-delivery, req-expert-routing |
| [spec-verification-contract](spec-verification-contract.md) | Check the role text, skill text, wiki pages, and rendered harness configuration. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation |
| [spec-moex-page](spec-moex-page.md) | Define the mixture-of-experts wiki page and its coordination routes. | req-moex-explanation |
| [spec-moex-delivery](spec-moex-delivery.md) | Copy the current wiki page and its index link to each generated repository layout. | req-moex-nix-delivery |
| [spec-release-role](spec-release-role.md) | Define the phase 5 interface of the artifact release expert. | req-release-role, req-expert-routing |
| [spec-contract-driven](spec-contract-driven.md) | Define contract-first authorship and master-routed feasibility review. | req-contract-driven-spec, req-expert-routing |
| [spec-interactive-recommend](spec-interactive-recommend.md) | Define the option interview and its approval gate. | req-interactive-recommend |
| [spec-parallel-implementation](spec-parallel-implementation.md) | Define task dependencies and artifact-master phase 4 batching. | req-parallel-implementation, req-expert-routing |

## Decisions

- [adr-canonical-role-source](../decisions/adr-canonical-role-source.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
- [adr-moex-page-variants](../decisions/adr-moex-page-variants.md)
- [adr-release-routing](../decisions/adr-release-routing.md)
- [adr-master-coordination](../decisions/adr-master-coordination.md)
- [adr-contract-first](../decisions/adr-contract-first.md)
- [adr-opencode-coordination-permissions](../decisions/adr-opencode-coordination-permissions.md)
