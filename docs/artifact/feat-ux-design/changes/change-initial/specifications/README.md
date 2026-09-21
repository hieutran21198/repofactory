# Specifications: UX Design

**Change:** [Initial](../../../changes/change-initial/README.md)

## Solution

The `services/factory` component adds optional UX Design to generated artifact-driven
repositories. The factory declares the enable setting with `mkBoolOpt` and keeps it off by
default. The declaration renders no file. An off selection keeps all generated files
byte-identical and adds no role, tool configuration, workflow rule, or Design artifact.

An on selection uses a conditional composition merge. The merge adds the designer expert, its
OpenCode permission, optional role chapters, and the Design template. It does not change an
always-copied asset. The designer expert joins phase 2, which is the Specs and ADRs phase.

The solution expert owns the Specs and ADRs. The designer expert owns `design/README.md`. Both
experts use the accepted Requirements. The designer expert also follows the Specs and ADRs as
constraints.

The Design artifact is part of the phase 2 output. It has UX, Layout, Interaction, Components,
and Design System sections. The artifact records reused items and required additions. It uses the
existing design system and theme. It does not own business behavior, domain rules, permissions,
or constraints.

The optional design tool setting is `use`. Its value is `unset` or `figma`. The design-tool domain
declares this setting only. For `figma`, the artifact-driven composition writes the applicable
harness setting. The setting connects each selected harness through Model Context Protocol (MCP),
`figma-ui-mcp`, and Figma Desktop. A tool can help the designer expert, but it is never a gate for
the Design artifact.

The Repository blueprint aggregate keeps the Domain model pattern. This change adds no bounded
context and no context relationship.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-ux-design-option](spec-ux-design-option.md) | Add UX Design only when the maintainer enables it. | req-enable-flag |
| [spec-design-tool](spec-design-tool.md) | Select an optional design tool without making it a gate. | req-design-tool |
| [spec-phase-placement](spec-phase-placement.md) | Put the Design artifact in the Specs and ADRs phase. | req-phase-placement |
| [spec-designer-expert](spec-designer-expert.md) | Define the designer expert inputs, scope, reuse rules, and harness boundary. | req-designer-scope |
| [spec-design-ownership](spec-design-ownership.md) | Keep business behavior and constraints outside the Design artifact. | req-ownership-boundary |
| [spec-parallel-design](spec-parallel-design.md) | Run design work with solution work and join both outputs before the phase commit. | req-parallel-workflow |
| [spec-design-artifact](spec-design-artifact.md) | Define the path and the five sections of the Design artifact. | req-design-output |

## Decisions

- [adr-design-tool-selection](../decisions/adr-design-tool-selection.md)
- [adr-designer-harness](../decisions/adr-designer-harness.md)
- [adr-design-artifact-placement](../decisions/adr-design-artifact-placement.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
