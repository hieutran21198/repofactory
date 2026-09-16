# Requirements: Artifact master

**Change:** [Master coordination](../../../changes/change-master-coordination/README.md)

## Business need

A software team runs artifact-driven changes through five phases with
expert roles. The solution expert calls other subagents to coordinate
feasibility reviews and phase 4 work. This coordination is unstable
on the harness in use. It also costs many tokens for coordination messages.
The team needs the artifact master to own all spawning and
coordination of experts. The team needs the solution expert to own
phase content only, with no subagent calls.

## Scope

- In scope: Coordination ownership by the artifact master for all experts.
- In scope: A no-subagent rule for the solution expert.
- In scope: Feasibility routing through the artifact master in phase 2.
- In scope: Phase 4 batching by the artifact master from recorded dependencies.
- In scope: Owner selection by the artifact master for an uncovered component.
- In scope: Updated wiki routing and updated expert help texts.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the content that a requirement, solution, or implementation expert owns.
- Out of scope: A status field or a phase-tracking field in a file.
- Out of scope: A record of chat messages in the repository.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Software team, user, artifact master, requirement expert, solution expert, implementation expert, artifact release expert | Coordination moved, Owner selected, Feasibility routed, Work batched, Release routed, Contract written, Constraint returned, Option recommended, Choice approved, Work sequenced |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-phase-control](req-phase-control.md) | The artifact master must control the order and the input of each phase. | Must |
| [req-expert-routing](req-expert-routing.md) | The artifact master must own coordination and must route each phase to its owner. | Must |
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
| [req-parallel-implementation](req-parallel-implementation.md) | The artifact master must batch phase 4 tasks and must run independent tasks in parallel. | Must |

## Acceptance

The artifact master owns all spawning and coordination of experts.
The solution expert owns phase content and calls no subagent. Each
feasibility review passes through the artifact master. Phase 4 runs
in batches from the recorded dependencies. An uncovered component
gets its owner from the artifact master. The wiki describes this
routing. Each specification starts from a contract with resolved
constraints. Phase 4 keeps one commit.
