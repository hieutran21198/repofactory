# Specifications: Artifact master

**Change:** [Mixture of experts wiki](../../../changes/change-mixture-of-experts-wiki/README.md)

## Solution

The repository supplies one English wiki page that explains the mixture of experts. The page
defines the coordinator boundary, the phase owners, the two plans, harness rendering, and skill
load. Tables show the role and phase routes. The page links to the artifact-driven documentation
for more details, but its explanation does not depend on that link.

The `services/factory` component copies the page through the artifact-driven Nix composition.
The single and multiple repository layouts each have one page mirror. The DDD variants use the
mirror for their repository layout because the page has no DDD-specific content. Each wiki index
links to the page.

The Repository blueprint aggregate stays a domain model. Its composition rules include the
self-contained wiki page and its index link. The current coordination, phase message, harness,
and verification contracts do not change.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-coordination-protocol](spec-coordination-protocol.md) | Control, route, and commit one change phase by phase. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary |
| [spec-phase-messages](spec-phase-messages.md) | Give the user phase messages with required fields. | req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |
| [spec-harness-delivery](spec-harness-delivery.md) | Supply one role behavior to each selected harness. | req-harness-delivery |
| [spec-verification-contract](spec-verification-contract.md) | Check the role, skill, and rendered harness contract. | req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication |
| [spec-moex-page](spec-moex-page.md) | Define the mixture-of-experts wiki page and its required explanation. | req-moex-explanation |
| [spec-moex-delivery](spec-moex-delivery.md) | Copy the wiki page and its index link to each generated repository layout. | req-moex-nix-delivery |

## Decisions

- [adr-canonical-role-source](../decisions/adr-canonical-role-source.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
- [adr-moex-page-variants](../decisions/adr-moex-page-variants.md)
