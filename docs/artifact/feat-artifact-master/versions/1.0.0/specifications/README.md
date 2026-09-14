# Specifications: Artifact master

**Change:** [Initial](../../../changes/change-initial/README.md)

## Solution

The repository factory supplies one canonical artifact-master role body. Each harness renders that body as its artifact-master role. The artifact-master skill loads the rendered role for the harness in use. The role defines phase control and the user message contract. It delegates all phase content to the phase owner.

The factory tests the canonical role, the skill, and the rendered harness output. The tests check the required text and the behavior contract. They do not require a saved chat message.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-coordination-protocol](spec-coordination-protocol.md) | Control, route, and commit one change phase by phase. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary |
| [spec-phase-messages](spec-phase-messages.md) | Give the user phase messages with required fields. | req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |
| [spec-harness-delivery](spec-harness-delivery.md) | Supply one role behavior to each selected harness. | req-harness-delivery |
| [spec-verification-contract](spec-verification-contract.md) | Check the role, skill, and rendered harness contract. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |

## Decisions

- [adr-canonical-role-source](../decisions/adr-canonical-role-source.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
