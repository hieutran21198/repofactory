# Specifications: UX Design

**Change:** [pencil-command](../../../changes/change-pencil-command/README.md)

## Solution

The `services/factory` component keeps UX Design optional. This change replaces the canonical
Pencil MCP command only. The `unset` and `figma` behavior stays unchanged. The entry name stays
`pencil`.

The canonical Pencil entry runs the local `pen-mcp-server` command with the `--app desktop`
selector. The three harness modules render this command under their existing paths. The command
connects to the running Pencil Desktop application. The application supplies the open `.pen`
document.

The entry gates, the merge rules, and the render paths stay unchanged. The Repository blueprint
aggregate keeps the Domain model pattern. This change adds no bounded context and no context
relationship. Version 2.1.0 keeps all eight specifications. This change ships the content of
`spec-pencil-mcp` only.

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
