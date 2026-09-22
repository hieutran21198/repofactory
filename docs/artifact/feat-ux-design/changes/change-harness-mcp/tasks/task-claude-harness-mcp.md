# task-claude-harness-mcp: Add the Claude Figma MCP adapter

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-harness-ux-design-signal
**can-parallel:** no
**Parallel reason:** This task follows the shared signal and changes the same context and aggregate.

## Goal

Let the Claude harness own its mergeable Figma MCP setting and its `.mcp.json` output.

## Files

- `services/factory/domain/agent/harness/claude/default.nix`
- `services/factory/domain/agent/harness/claude/tests/eval.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Declare `domain.agent.harness.claude.mcp-servers` with `_utils.mkAttrsOpt`.
2. Use `lib.types.json` for its values.
3. Set its default to an empty attribute set.
4. Keep the existing `settings` output in `.claude/settings.json`.
5. Gate the server entry on the three activation inputs.
6. Do not read `mcp-servers` in the server-entry gate.
7. Add only `mcp-servers."figma-ui-mcp"` in the activation gate.
8. Set `command = "npx"` in the canonical server.
9. Set `args = [ "-y" "figma-ui-mcp" ]` in the canonical server.
10. Set `env.FIGMA_UI_MCP_TARGET = "Figma Desktop"` in the canonical server.
11. Do not use `lib.mkForce`.
12. Compare the final merged server value with the canonical server when the adapter is active.
13. Fail the evaluation when the final values differ.
14. Gate `.mcp.json` separately on a non-empty final `mcp-servers` value.
15. Render the final value at `files.".mcp.json".json.mcpServers`.
16. Set `files.".mcp.json".copyMode = "copy"`.
17. Add the module-local evaluation for the Claude contract.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/claude/tests/eval.nix`.
2. Check each activation input with one off fixture.
3. Use `harnessUses = [ "claude" ]` and a false signal in one fixture.
4. Assert that this fixture has empty `mcp-servers` and no `.mcp.json` file.
5. Check the exact command, arguments, environment, output path, and copy mode.
6. Check two `mcp-servers` entries in one `.mcp.json` file.
7. Check that `.claude/settings.json` stays separate and unchanged.
8. Check the final-value assertion with the real module system in the final task.
