# Requirements: UX Design

**Change:** [design-tool-pencil](../../../changes/change-design-tool-pencil/README.md)

## Business need

A software team uses the artifact-driven workflow to build a feature. For some features, the
team also needs user experience design: the UX flow, the layout, the interaction, and the
component design. Today the workflow has no designer expert and no Design artifact, so the team
gets no UX output from the workflow.

The team needs an optional UX Design capability. The factory maintainer selects it with the
option `artifact-driven.ux-design.enable`. The default is `false`. When the option is off, the
existing workflow does not change. When the option is on, a designer expert joins the Specs and
ADRs phase and produces a Design artifact for the feature.

The designer expert uses the accepted Requirements as the baseline. It uses the current Specs
and the current ADRs as constraints. It uses the existing design system, the theme, and the UI
components of the repository. It reuses existing components and tokens when reuse fits. It
defines new components and variables only when reuse does not fit.

The factory maintainer selects the design tool with `domain.design-tool.use`. The permitted
values are `unset` (the default), `figma`, and `pencil`, where `pencil = pen.dev (.pen)`. The
`pencil` value selects the pen.dev integration through the MCP server named `pencil`, working
on `.pen` files. The selection is passive: it names the tool only. The designer expert must
still produce the full Design artifact when no tool is available.

## Scope

- In scope: The enable option, its default, and unchanged behavior when disabled.
- In scope: The optional design tool integration and the required Design artifact without it.
- In scope: The `pencil` value for the pen.dev integration next to `figma` and `unset`.
- In scope: UX Design inside the Specs and ADRs phase, with no separate phase.
- In scope: The inputs, the scope, and the reuse preference of the designer expert.
- In scope: The ownership boundary between Design and Requirements, Specs, and ADRs.
- In scope: The parallel workflow of the solution expert and the designer expert.
- In scope: The structure of the Design artifact.
- Out of scope: The specifications, decisions, tasks, and code of this change.
- Out of scope: An event mechanism for the tool selection.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the business behavior, domain rules, permissions, or constraints.
- Out of scope: A new design system or a new theme per feature.
- Out of scope: A status field or a phase-tracking field in a file.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Factory maintainer, software team, requirement expert, solution expert, designer expert | UX Design enabled, Design tool selected, Requirements accepted, Design completed |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-enable-flag](req-enable-flag.md) | The factory must offer UX Design as an option that stays off unless selected. | Must |
| [req-design-tool](req-design-tool.md) | The designer expert should use the selected design tool, but must produce the Design artifact without it. | Should |
| [req-phase-placement](req-phase-placement.md) | UX Design must belong to the Specs and ADRs phase, with no separate phase. | Must |
| [req-designer-scope](req-designer-scope.md) | The designer expert must design from fixed inputs and must prefer reuse. | Must |
| [req-ownership-boundary](req-ownership-boundary.md) | The Design artifact must not own business behavior, domain rules, permissions, or constraints. | Must |
| [req-parallel-workflow](req-parallel-workflow.md) | The designer expert must work in parallel with the solution expert under Specs and ADRs constraints. | Must |
| [req-design-output](req-design-output.md) | The Design artifact must hold UX, Layout, Interaction, Components, and Design System sections. | Must |

## Acceptance

When the option is off, the workflow produces the same artifacts as before this change. When the
option is on, the Specs and ADRs phase also produces a Design artifact that covers UX flow,
layout, interaction, components, and the design system. The Design artifact reuses existing
components and tokens when reuse fits and styles the feature from the existing system and theme.
When the maintainer selects `pencil`, the designer expert may use pen.dev through the MCP
server named `pencil` on an open `.pen` document. When the maintainer selects `figma`, the
existing behavior stays. When the value is `unset`, the tool is unavailable, or an operation
fails, the designer expert still produces the full Design artifact.
