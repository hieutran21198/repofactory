# Requirements: Artifact master

**Change:** [Initial](../../../changes/change-initial/README.md)

## Business need

A software team uses the artifact master to control an artifact-driven change. The artifact
master must keep the five phases in order and must use the expert that owns each phase. It must
also help the user direct the work without a review of the repository after each action.

For each phase, the user needs to know its purpose, input, output, owner, and required action.
The user also needs useful progress information during a build. After the build, the user needs
a short handoff that makes the result and the next action easy to check.

## Scope

- In scope: The order, input, output, owner, approval, and commit boundary of each phase.
- In scope: The boundary between coordination and the content that each expert owns.
- In scope: The phase information that the artifact master gives to the user.
- In scope: User choices, user actions, build progress, and phase handoffs.
- In scope: Communication for phase 4, which has no separate phase plan.
- In scope: The same artifact master behavior in each harness in use.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the content that a requirement, solution, or implementation expert owns.
- Out of scope: A status field or a phase-tracking field in a file.
- Out of scope: A record of chat messages in the repository.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Software team, user, artifact master, requirement expert, solution expert, implementation expert | Phase plan proposed, phase plan approved, phase build started, phase committed, phase handoff given |

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

## Acceptance

For one full change, the artifact master controls each phase and routes its content to the correct
expert. At each gate, the user can identify the work, make required choices, and approve the next
build. During each build, the user gets useful progress information. Each completed phase has one
commit and one phase handoff. Each harness in use gives the same behavior.
