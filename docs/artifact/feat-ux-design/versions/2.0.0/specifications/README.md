# Specifications: UX Design

**Change:** [design-tool-pencil](../../../changes/change-design-tool-pencil/README.md)

## Solution

The `services/factory` component keeps UX Design optional. The enable setting stays off by
default. An off selection adds no role, tool setting, workflow rule, or Design artifact.

The design-tool domain declares the passive `use` selection. Its permitted values are `unset`,
`figma`, and `pencil`. Its default is `unset`. The `pencil` value means pen.dev with an open
`.pen` document. The design-tool domain emits no Model Context Protocol (MCP) setting.

The artifact-driven composition sets only the internal UX Design signal in the harness domain.
Each harness module owns its mergeable MCP entries. The existing `figma-ui-mcp` behavior stays
unchanged. A selected Pencil adapter uses the MCP entry key and local stdio command `pencil`.
The pen.dev setup supplies this command and connects it to the running local host.

The Pencil adapter operates on the open `.pen` document. The adapter contract gives no remote
access and no filesystem privilege. The designer expert always produces the full Design artifact.
The `unset` value, an unavailable tool, or a failed operation does not block that artifact.

The Repository blueprint aggregate keeps the Domain model pattern. This change adds no bounded
context and no context relationship.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-ux-design-option](spec-ux-design-option.md) | Add UX Design only when the maintainer enables it. | req-enable-flag |
| [spec-design-tool](spec-design-tool.md) | Select `unset`, `figma`, or `pencil` without making the tool a gate. | req-design-tool |
| [spec-pencil-mcp](spec-pencil-mcp.md) | Let each harness own its local Pencil MCP entry. | req-design-tool |
| [spec-phase-placement](spec-phase-placement.md) | Put the Design artifact in the Specs and ADRs phase. | req-phase-placement |
| [spec-designer-expert](spec-designer-expert.md) | Define the designer expert inputs, scope, reuse rules, and tool boundary. | req-designer-scope, req-design-tool |
| [spec-design-ownership](spec-design-ownership.md) | Keep business behavior and constraints outside the Design artifact. | req-ownership-boundary |
| [spec-parallel-design](spec-parallel-design.md) | Run design work with solution work and join both outputs before the phase commit. | req-parallel-workflow |
| [spec-design-artifact](spec-design-artifact.md) | Define the path and the five sections of the Design artifact. | req-design-output |

## Decisions

- [adr-design-tool-selection](../decisions/adr-design-tool-selection.md)
- [adr-designer-harness](../decisions/adr-designer-harness.md)
- [adr-design-artifact-placement](../decisions/adr-design-artifact-placement.md)
- [adr-repository-blueprint-pattern](../decisions/adr-repository-blueprint-pattern.md)
