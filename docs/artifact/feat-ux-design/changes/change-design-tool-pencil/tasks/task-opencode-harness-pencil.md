# task-opencode-harness-pencil: Add the OpenCode Pencil MCP entry

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool, spec-pencil-mcp, spec-designer-expert
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-claude-harness-pencil
**can-parallel:** no
**Parallel reason:** This task follows the Claude entry and changes the same context and aggregate.

## Goal

Let the OpenCode harness own its mergeable `pencil` MCP entry and render it under `mcp` in
`.opencode/opencode.jsonc`.

## Scope

- `services/factory/domain/agent/harness/opencode/default.nix`
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`

This task changes no other file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Define the Pencil server name `pencil`.
2. Define the canonical Pencil entry with `type = "local"`, `command = ["pencil"]`, and
   `enabled = true`. The entry has no `environment` field.
3. Add the Pencil activation gate: the selected OpenCode harness, the internal UX Design signal,
   and `designTool == "pencil"`.
4. Add only the nested `settings.mcp.pencil` entry in the Pencil gate.
5. Keep the entry gate independent from the final `settings` value.
6. Keep the OpenCode settings output and the Figma entry unchanged.
7. Do not use `lib.mkForce`.
8. Add a Pencil conflict assertion. It compares the final merged `pencil` entry with the canonical
   Pencil entry.
9. Add the Pencil cases to the module-local evaluation: one off case for each activation input,
   the exact canonical entry, the rendered file, the preservation of an unrelated setting and a
   differently named MCP entry, and the conflict case.
10. Assert that the `figma` case keeps the canonical Figma entry and adds no `pencil` entry.
11. Assert that the `pencil` case adds no `figma-ui-mcp` entry.
12. Keep the existing Figma cases unchanged.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/opencode/tests/eval.nix`.
2. Check the three Pencil activation inputs with one off fixture each: the selected harness is
   absent, the signal is off, and the value is not `pencil`.
3. Assert that each off fixture has no module-owned `pencil` entry.
4. Assert that the module adds the exact canonical `pencil` entry when all three conditions are
   true.
5. Assert that the entry contains no `url`, `environment` field, document path, repository path,
   remote endpoint, or filesystem permission.
6. Assert that the rendered `.opencode/opencode.jsonc` uses `mcp.pencil`.
7. Assert that the unrelated `agent.explore.model` setting and the differently named MCP entry
   stay unchanged.
8. Assert that a different final `pencil` value fails the evaluation. The evaluation fails through
   an option-merge conflict or the module assertion.
9. Assert that the `figma` case adds no `pencil` entry and the `pencil` case adds no
   `figma-ui-mcp` entry.
10. Assert that every Figma assertion stays unchanged and passes.

## Definition of done

- The OpenCode module adds the exact canonical `pencil` entry only when all three conditions are
  true.
- The module adds no `pencil` entry when one condition is false.
- The module preserves unrelated settings and MCP entries with different names.
- The module fails evaluation for a different final `pencil` value.
- The module-local evaluation passes.
