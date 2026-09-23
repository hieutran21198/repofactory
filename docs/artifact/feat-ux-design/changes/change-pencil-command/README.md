# Change: pencil-command

**Feature:** [UX Design](../../README.md)
**From:** 2.0.0
**To:** 2.1.0
**Type:** Specifications

## Reason

The canonical `pencil` entry uses bare `pencil` in 3 harnesses and exits immediately, which causes MCP -32000 Connection closed. The verified binary `pen-mcp-server --app desktop` connects to Pencil Desktop. This change fixes the canonical command only and keeps both figma/pencil tools, keeps the entry name `pencil`, and keeps the Design artifact unblocked.

## Artifacts

- [Specifications](specifications/README.md)
