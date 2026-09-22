# task-opencode-harness-mcp: Add the OpenCode Figma MCP adapter

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-claude-harness-mcp
**can-parallel:** no
**Parallel reason:** This task follows the Claude task and changes the same context and aggregate.

## Goal

Let the OpenCode harness own its nested Figma MCP setting and its JSON output.

## Files

- `services/factory/domain/agent/harness/opencode/default.nix`
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Gate the server entry on the three activation inputs.
2. Add only `settings.mcp."figma-ui-mcp"` in the activation gate.
3. Set `type = "local"` in the canonical server.
4. Set `command = [ "npx" "-y" "figma-ui-mcp" ]` in the canonical server.
5. Set `environment.FIGMA_UI_MCP_TARGET = "Figma Desktop"` in the canonical server.
6. Set `enabled = true` in the canonical server.
7. Use `environment`. Do not use `env`.
8. Do not use `lib.mkForce`.
9. Keep the `.opencode/opencode.jsonc` renderer.
10. Preserve each unrelated OpenCode setting.
11. Preserve each MCP entry with a different name.
12. Compare the final merged server value with the canonical server when the adapter is active.
13. Fail the evaluation when the final values differ.
14. Add the module-local evaluation for the OpenCode contract.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/opencode/tests/eval.nix`.
2. Confirm that each activation condition has an off case.
3. Keep `agent.explore.model` in the false-signal fixture.
4. Keep a differently named MCP entry in the false-signal fixture.
5. Assert that the fixture does not add `figma-ui-mcp`.
6. Assert that the two unrelated values stay unchanged.
7. Check the exact canonical server in `.opencode/opencode.jsonc`.
8. Check the final-value assertion with the real module system in the final task.
