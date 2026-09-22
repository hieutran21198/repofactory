# task-claude-harness-pencil: Add the Claude Pencil MCP entry

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool, spec-pencil-mcp, spec-designer-expert
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-design-tool-pencil-enum
**can-parallel:** no
**Parallel reason:** This task follows the shared enum value and changes the same context and aggregate.

## Goal

Let the Claude harness own its mergeable `pencil` MCP entry and render it under `mcpServers` in
`.mcp.json`.

## Scope

- `services/factory/domain/agent/harness/claude/default.nix`
- `services/factory/domain/agent/harness/claude/tests/eval.nix`

This task changes no other file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Define the Pencil server name `pencil`.
2. Define the canonical Pencil entry with `type = "stdio"`, `command = "pencil"`, empty `args`, and
   empty `env`.
3. Add the Pencil activation gate: the selected Claude harness, the internal UX Design signal, and
   `designTool == "pencil"`.
4. Add only the nested `mcp-servers.pencil` entry in the Pencil gate.
5. Keep the entry gate independent from the final `mcp-servers` value.
6. Keep the `.mcp.json` file gate, the `copyMode = "copy"` value, and the Figma entry unchanged.
7. Do not use `lib.mkForce`.
8. Add a Pencil conflict assertion. It compares the final merged `pencil` entry with the canonical
   Pencil entry.
9. Add the Pencil cases to the module-local evaluation: one off case for each activation input,
   the exact canonical entry, the rendered file, two entries in one file, the preservation of a
   differently named entry, and the conflict case.
10. Assert that the `figma` case keeps the canonical Figma entry and adds no `pencil` entry.
11. Assert that the `pencil` case adds no `figma-ui-mcp` entry.
12. Keep the existing Figma cases unchanged.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/claude/tests/eval.nix`.
2. Check the three Pencil activation inputs with one off fixture each: the selected harness is
   absent, the signal is off, and the value is not `pencil`.
3. Assert that each off fixture has no module-owned `pencil` entry and no `.mcp.json` file.
4. Assert that the module adds the exact canonical `pencil` entry when all three conditions are
   true.
5. Assert that the entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
6. Assert that the rendered `.mcp.json` uses `mcpServers.pencil` and `copyMode = "copy"`.
7. Assert that two MCP entries render in one `.mcp.json` file.
8. Assert that a differently named MCP entry stays unchanged.
9. Assert that a different final `pencil` value fails the evaluation. The evaluation fails through
   an option-merge conflict or the module assertion.
10. Assert that the `figma` case adds no `pencil` entry and the `pencil` case adds no
    `figma-ui-mcp` entry.
11. Assert that every Figma assertion stays unchanged and passes.

## Definition of done

- The Claude module adds the exact canonical `pencil` entry only when all three conditions are
  true.
- The module adds no `pencil` entry when one condition is false.
- The module preserves unrelated settings and MCP entries with different names.
- The module fails evaluation for a different final `pencil` value.
- The module-local evaluation passes.
