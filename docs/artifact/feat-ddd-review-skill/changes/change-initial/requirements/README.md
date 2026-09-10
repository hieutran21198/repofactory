# Requirements: DDD review skill

## Business need

A project team that uses domain-driven design must review context canvases, aggregate invariants,
and artifact links often. The requirement expert and the solution expert need one shared skill
that gives the same review procedure and keeps the ownership of each phase.

## Scope

- In scope: One shared review skill for a project that selects artifact-driven documentation and DDD.
- In scope: Checks of strategic canvases, tactical aggregate artifacts, and DDD artifact links.
- In scope: A report that gives each problem and its phase owner.
- Out of scope: A change to a domain artifact by the skill.
- Out of scope: A change to the ownership of a DDD phase.
- Out of scope: A skill for a project without a selected repository architecture.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Project team, coding agent, requirement expert, solution expert | DDD review requested, DDD problem reported |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-ddd-review-skill-shipped](req-ddd-review-skill-shipped.md) | A selected DDD project must get the shared skill in each harness in use. | Must |
| [req-ddd-review-guidance](req-ddd-review-guidance.md) | The skill must review the DDD artifacts and report each problem with its owner. | Must |
| [req-ddd-review-skill-selection](req-ddd-review-skill-selection.md) | The factory must not ship the skill without artifact-driven documentation, DDD, and a repository architecture. | Must |

## Acceptance

A generated project that selects artifact-driven documentation, DDD, and a repository architecture
has the `ddd-review` skill in each harness in use. The skill reviews the selected DDD artifacts
and reports problems without changing them. A project that does not make all three selections has
no skill.
