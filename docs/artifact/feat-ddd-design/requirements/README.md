# Requirements: DDD design

## Business need

Project teams need one method to find the boundaries of a system before they design the parts
inside each boundary. Without a method, each feature invents its own vocabulary and its own
boundaries. The teams then build components that overlap, and the agents that write the
artifacts cannot tell which component owns a rule.

Domain-driven design (DDD) gives this method. The strategic design finds the subdomains, the
bounded contexts, and the shared language. The tactical design then models the aggregates, the
commands, and the events inside each bounded context. The factory must offer DDD as a design
method, and the artifact-driven documentation model must use it when a project selects it.

## Scope

- In scope: A factory option that selects DDD as the design method.
- In scope: A design guide for the strategic design and the tactical design.
- In scope: A shared location and templates for the domain model of a project.
- In scope: DDD steps for the requirement expert and the solution expert.
- In scope: One rule that maps a bounded context to a component.
- Out of scope: An implementation expert role for phase 4.
- Out of scope: A domain model for the factory itself.
- Out of scope: Code generators or a text language for the domain model.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-design-option](req-design-option.md) | A project must select DDD with one factory option. | Must |
| [req-ddd-guidance](req-ddd-guidance.md) | A project that selects DDD must get one design guide that covers the strategic design and then the tactical design. | Must |
| [req-domain-model-artifacts](req-domain-model-artifacts.md) | A project that selects DDD must get one shared location and templates for its domain model. | Must |
| [req-role-ddd-extension](req-role-ddd-extension.md) | The requirement expert and the solution expert must do the DDD steps only when the project selects DDD. | Must |
| [req-context-boundary-rule](req-context-boundary-rule.md) | The design guide must give one rule that maps a bounded context to a component. | Must |

## Acceptance

A project that sets the DDD option gets the design guide, the domain model location with its
templates, and roles with the DDD steps. A project that does not set the option gets none of
these files, and its roles do not change.
