# task-codex-pencil-command: Set the Codex Pencil MCP command

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-pencil-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-opencode-pencil-command
**can-parallel:** no
**Parallel reason:** This task follows the OpenCode entry and changes the same context and aggregate.

## Goal

Replace the Codex canonical Pencil entry with `command = "pen-mcp-server"` and
`args = [ "--app" "desktop" ]`, and update the local check fixtures.

## Scope

- `services/factory/domain/agent/harness/codex/default.nix`
- `services/factory/domain/agent/harness/codex/tests/eval.nix`

This task changes no other file.

## Steps

1. Keep the Pencil server name `pencil` and the activation gate unchanged.
2. Set the canonical Pencil entry to `command = "pen-mcp-server"` and
   `args = [ "--app" "desktop" ]`.
3. Keep no `env` field in the entry.
4. Keep the merge point, the render path, the `.codex/config.toml` file gate, the
   `copyMode = "copy"` value, and the conflict assertion. Do not use `lib.mkForce`.
5. Update the fixture `canonicalPencilServer` to the same command and arguments.
6. Assert that `command == "pen-mcp-server"`, `args == [ "--app" "desktop" ]`, and that no `env`
   field exists.
7. Keep the no-forbidden-field assertion and the fixture values.
8. Keep the conflict fixture with a different leaf value of the new entry.
9. Keep the off cases, the rendered `.codex/config.toml` cases, the unrelated setting, the
   differently named entry, the `figma` cases, and the existing Figma assertions.
10. Do not add a check of tool availability or tool operations.
11. Do not add an event mechanism.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/codex/tests/eval.nix`.
2. Assert that the module adds the exact canonical entry when all three conditions are true.
3. Assert that the entry keys are exactly `args` and `command`, and that no `env` key exists.
4. Assert that `command == "pen-mcp-server"` and `args == [ "--app" "desktop" ]`.
5. Assert that the entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
6. Assert that each off fixture has no module-owned `pencil` entry.
7. Assert that the rendered `.codex/config.toml` uses `mcp_servers.pencil` and
   `copyMode = "copy"`.
8. Assert that the unrelated setting and the differently named MCP entry stay unchanged.
9. Assert that a different final `pencil` value fails the evaluation. The evaluation fails through
   an option-merge conflict or the module assertion.
10. Assert that the `figma` case adds no `pencil` entry and the `pencil` case adds no
    `figma-ui-mcp` entry.

## Definition of done

- The Codex canonical entry runs `pen-mcp-server` with `--app desktop`.
- The entry has no `env` field.
- The fixtures exercise the new command and arguments together.
- The module fails evaluation for a different final `pencil` value.
- The module-local evaluation passes.
