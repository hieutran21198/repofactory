# Requirements: Artifact master

**Change:** [Governance](../../../changes/change-governance/README.md)

## Business need

A software team runs artifact-driven changes through five phases with expert
roles. The team needs four governance rules. It needs a low-cost release role
for the mechanical version copy. It needs a contract-first rule for phase 2
with feasibility review. It needs an interactive rule with options and one
recommendation for phases 1 and 2. It needs a parallel rule for phase 4 that
follows the dependencies that phase 3 records.

## Scope

- In scope: A release role that owns the mechanical phase 5 copy.
- In scope: A contract-first rule for phase 2 with feasibility review.
- In scope: An interactive rule with options and one recommendation.
- In scope: A parallel rule for phase 4 that follows phase 3 dependencies.
- In scope: Rerouted expert routing with the solution expert as version gate only.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the content that a requirement, solution, or implementation expert owns.
- Out of scope: A status field or a phase-tracking field in a file.
- Out of scope: A record of chat messages in the repository.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Software team, user, artifact master, requirement expert, solution expert, implementation expert, artifact release expert | Release routed, Contract written, Constraint returned, Option recommended, Choice approved, Work sequenced |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-phase-control](req-phase-control.md) | The artifact master must control the order and the input of each phase. | Must |
| [req-expert-routing](req-expert-routing.md) | The artifact master must route each phase to its owner. | Must |
| [req-content-ownership](req-content-ownership.md) | The artifact master must coordinate the work without taking ownership of phase content. | Must |
| [req-commit-boundary](req-commit-boundary.md) | The artifact master must keep one commit boundary for each phase. | Must |
| [req-harness-delivery](req-harness-delivery.md) | Each harness in use must receive the same artifact master behavior. | Must |
| [req-phase-brief](req-phase-brief.md) | Each phase must start with its phase, purpose, input, output, and owner. | Must |
| [req-user-direction](req-user-direction.md) | The artifact master must show choices and actions, and must request approval when required. | Must |
| [req-build-progress](req-build-progress.md) | The artifact master must give useful progress information during a phase build. | Must |
| [req-phase-handoff](req-phase-handoff.md) | The artifact master must give a complete handoff after each phase build. | Must |
| [req-phase-four-communication](req-phase-four-communication.md) | The artifact master must communicate phase 4 without a separate phase plan. | Must |
| [req-concise-communication](req-concise-communication.md) | The artifact master must keep phase messages short and useful. | Must |
| [req-moex-explanation](req-moex-explanation.md) | The wiki must explain the mixture-of-experts roles and their routing. | Must |
| [req-moex-nix-delivery](req-moex-nix-delivery.md) | The factory must deliver the wiki page to a generated repository through the Nix wiki assets copy. | Must |
| [req-release-role](req-release-role.md) | The artifact release expert must own the mechanical phase 5 copy. | Must |
| [req-contract-driven-spec](req-contract-driven-spec.md) | The solution expert must write the contract first and must resolve feasibility constraints. | Must |
| [req-interactive-recommend](req-interactive-recommend.md) | Each expert must interview the user with options and one recommendation when it sees a better path. | Must |
| [req-parallel-implementation](req-parallel-implementation.md) | Phase 4 must run tasks in parallel where the recorded dependencies permit it. | Must |

## Acceptance

The artifact master still controls each phase and routes its content to the
correct owner. The artifact release expert copies each version without edits.
Each specification starts from a contract with resolved constraints. Each
better path passes a user interview with options and one recommendation.
Phase 4 runs independent tasks in parallel and keeps one commit.
