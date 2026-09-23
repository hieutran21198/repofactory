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
relationship. Only `spec-pencil-mcp` changes at version 2.1.0.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-pencil-mcp](spec-pencil-mcp.md) | Let each harness own its local Pencil MCP entry. | req-design-tool |
