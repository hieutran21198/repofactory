# req-design-tool: Use an optional design tool, but require the Design artifact without it

**Master:** [Requirements](README.md)
**Priority:** Should
**Context:** context-factory

## Statement

The designer expert should use the optional design tool integration when the repository selects
it. The selection uses `domain.design-tool.use`, for example `"figma"`. The tool is an
implementation detail. The designer expert must still produce the required Design artifact when
no external tool is available.

## Acceptance criteria

- Given a selected design tool, when the designer expert works, then it may inspect designs, components, and variables through the tool integration.
- Given a selected design tool, when the designer expert works, then it may create frames, layouts, and components, reuse components, modify designs, apply variables, and capture screenshots through the tool integration.
- Given no external tool, when the designer expert works, then it still produces the full Design artifact for the feature.

## Notes

The example integration is Agent Harnesses with MCP to `figma-ui-mcp` to Figma Desktop. Phase 2
owns the tool contract. The absence of a tool never blocks the Design artifact.
