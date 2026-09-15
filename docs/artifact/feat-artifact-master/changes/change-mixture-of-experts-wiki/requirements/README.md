# Requirements: Artifact master

**Change:** [Mixture of experts wiki](../../../changes/change-mixture-of-experts-wiki/README.md)

## Business need

A software team uses the artifact master and the expert roles without one shared explanation of
the mixture-of-experts idea behind them. The team needs one wiki page that explains the harness
roles that artifact-driven uses: the artifact master as coordination only, the requirement
expert, the solution expert, and the implementation experts as content owners, and the routing
that connects them.

An end-user maintainer works in a generated repository that has no copy of this explanation. The
maintainer needs the same wiki page delivered into the generated repository through the Nix wiki
assets copy, the same way the existing wiki docs arrive, so that the page is self-contained and
the maintainer can copy it.

## Scope

- In scope: Wiki content that explains the coordinator role versus the expert roles.
- In scope: Wiki content that explains Plan-Pn then Build-Pn routing.
- In scope: Wiki content that explains coordinate-plan versus execution-plan.
- In scope: Wiki content that explains harness rendering from canonical source to each harness
  and skill load.
- In scope: The canonical wiki source, the Nix assets mirrors, the `default.nix` file entries
  with `copyMode="copy"` for the single and multiple layouts (and the ddd variant if needed),
  and the wiki index update.
- In scope: English language and a self-contained page that the end-user can copy.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the content that a requirement, solution, or implementation expert owns.
- Out of scope: A status field or a phase-tracking field in a file.
- Out of scope: A record of chat messages in the repository.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Software team, user, artifact master, requirement expert, solution expert, implementation expert, end-user maintainer | Wiki requested, wiki delivered, wiki copied |

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

## Acceptance

The artifact master still controls each phase and routes its content to the correct expert as
version 1.0.0 requires. A software team member and an end-user maintainer can read the
mixture-of-experts wiki page and can name the owner of each phase. A generated repository holds
a self-contained copy of the page that the maintainer can copy.
