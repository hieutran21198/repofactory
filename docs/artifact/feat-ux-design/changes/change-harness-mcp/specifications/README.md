# Specifications: UX Design

**Change:** [Harness owns each MCP setting](../../../changes/change-harness-mcp/README.md)

## Solution

The `services/factory` component keeps UX Design optional. The enable setting stays off by
default. An off selection adds no role, tool setting, workflow rule, or Design artifact.

The design-tool domain declares the `use` selection. Its value is `unset` or `figma`, and its
default is `unset`. The selection is passive. The design-tool domain emits no Model Context
Protocol (MCP) setting.

The artifact-driven composition sets an internal UX Design signal in the harness domain. It does
not write an MCP setting. Each harness module reads this signal and owns its MCP setting. When UX
Design is on and `use` is `figma`, each selected harness adds its `figma-ui-mcp` entry.

Each harness module keeps all unrelated settings and MCP entries. Each module checks that its
final `figma-ui-mcp` value is the canonical value. A different value causes an evaluation error.

The designer expert uses the selected tool when the tool is available. The designer expert
always produces the full Design artifact. A missing tool or a failed tool operation does not
block the Design artifact.

The Repository blueprint aggregate keeps the Domain model pattern. This change adds no bounded
context and no context relationship.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-ux-design-option](spec-ux-design-option.md) | Add UX Design only when the maintainer enables it. | req-enable-flag |
| [spec-design-tool](spec-design-tool.md) | Select an optional design tool without making it a gate. | req-design-tool |
| [spec-harness-mcp](spec-harness-mcp.md) | Let each harness own and render its MCP setting. | req-design-tool |
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
