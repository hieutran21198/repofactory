# req-design-tool: Use the selected design tool, but require the Design artifact without it

**Master:** [Requirements](README.md)
**Priority:** Should
**Context:** context-factory

## Statement

The designer expert should use the selected design tool integration when the repository selects
it. The selection uses `domain.design-tool.use` with the values `unset`, `figma`, and `pencil`,
where `pencil = pen.dev (.pen)`. The default is `unset`. The `pencil` value selects the pen.dev
integration through the MCP server named `pencil`, working on `.pen` files. The tool is an
implementation detail. The designer expert must still produce the required Design artifact when
no external tool is available.

## Acceptance criteria

- Given the value `pencil`, when the designer expert works, then it may use pen.dev through the MCP server named `pencil` on an open `.pen` document.
- Given the value `figma`, when the designer expert works, then the existing figma behavior stays.
- Given the value `unset`, when the designer expert works, then it still produces the full Design artifact for the feature.
- Given a selected but unavailable tool, when the designer expert works, then it still produces the full Design artifact for the feature.
- Given a failed tool operation, when the designer expert works, then it still produces the full Design artifact for the feature.

## Notes

Phase 2 owns the tool contract. The absence of a tool never blocks the Design artifact. The
name `pencil` means the pen.dev MCP server named `pencil`; it does not mean the Pencil
Project. Phase 2 confirms the MCP server name and the tool list.
