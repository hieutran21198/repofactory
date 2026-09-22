# task-codex-harness-mcp: Add the Codex Figma MCP adapter

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-opencode-harness-mcp
**can-parallel:** no
**Parallel reason:** This task follows the OpenCode task and changes the same context and aggregate.

## Goal

Let the Codex harness own its nested Figma MCP setting and its TOML output.

## Files

- `services/factory/domain/agent/harness/codex/default.nix`
- `services/factory/domain/agent/harness/codex/tests/eval.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Gate the server entry on the three activation inputs.
2. Add only `settings.mcp_servers."figma-ui-mcp"` in the activation gate.
3. Keep this definition outside the existing file-render gate.
4. Do not put this definition in a gate that reads `codex.settings`.
5. Set `command = "npx"` in the canonical server.
6. Set `args = [ "-y" "figma-ui-mcp" ]` in the canonical server.
7. Set `env.FIGMA_UI_MCP_TARGET = "Figma Desktop"` in the canonical server.
8. Do not use `lib.mkForce`.
9. Preserve each unrelated Codex setting.
10. Preserve each MCP entry with a different name.
11. Compare the final merged server value with the canonical server when the adapter is active.
12. Fail the evaluation when the final values differ.
13. Keep the `.codex/config.toml` renderer under its separate non-empty settings gate.
14. Add the module-local evaluation for the Codex contract.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/codex/tests/eval.nix`.
2. Confirm that each activation condition has an off case.
3. Confirm that unrelated settings and another MCP server stay unchanged.
4. Check the exact canonical server in `.codex/config.toml`.
5. Check that evaluation has no recursion error.
6. Check the final-value assertion with the real module system in the final task.
