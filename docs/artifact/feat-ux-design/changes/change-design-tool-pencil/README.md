# Change: design-tool-pencil

**Feature:** [UX Design](../../README.md)
**From:** 1.0.0
**To:** 2.0.0
**Type:** Requirements

## Reason

The user needs a choice of design tool. Today the factory permits only `unset` and `figma`
for `domain.design-tool.use`. The user wants integration with pen.dev and the ability to
replace the design tool with pencil or figma.

This change adds the enum value `pencil`, where `pencil = pen.dev (.pen)`. The value selects
the pen.dev integration through the MCP server named `pencil`, working on `.pen` files. The
values `figma` and `unset` stay. The default stays `unset`. The scope is passive selection
only: the `use` selection plus the designer-expert behavior contract. There is no event
mechanism. The Design artifact is never blocked.

This change starts from 1.0.0 in parallel with the unmerged change-harness-mcp
(1.0.0 -> 1.1.0). A rebase follows later if needed.

## Artifacts

- [Requirements](requirements/README.md)
