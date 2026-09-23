# task-opencode-pencil-command: Set the OpenCode Pencil MCP command

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-pencil-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-claude-pencil-command
**can-parallel:** no
**Parallel reason:** This task follows the Claude entry and changes the same context and aggregate.

## Goal

Replace the OpenCode canonical Pencil entry with the exact command array
`[ "pen-mcp-server" "--app" "desktop" ]` and update the local check fixtures.

## Scope

- `services/factory/domain/agent/harness/opencode/default.nix`
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`

This task changes no other file.

## Steps

1. Keep the Pencil server name `pencil` and the activation gate unchanged.
2. Set the canonical Pencil entry to `type = "local"`,
   `command = [ "pen-mcp-server" "--app" "desktop" ]`, and `enabled = true`.
3. Keep no `environment` field in the entry.
4. Keep the merge point, the render path, the settings output, and the conflict assertion. Do not
   use `lib.mkForce`.
5. Update the fixture `canonicalPencilServer` to the same command array.
6. Assert that `command == [ "pen-mcp-server" "--app" "desktop" ]` and that no `environment` field
   exists.
7. Keep the no-forbidden-field assertion and the fixture values.
8. Keep the conflict fixture with a different leaf value of the new entry.
9. Keep the off cases, the rendered `.opencode/opencode.jsonc` cases, the unrelated setting, the
   differently named entry, the `figma` cases, and the existing Figma assertions.
10. Do not add a check of tool availability or tool operations.
11. Do not add an event mechanism.

## Check

1. Run
   `nix-instantiate --eval --strict services/factory/domain/agent/harness/opencode/tests/eval.nix`.
2. Assert that the module adds the exact canonical entry when all three conditions are true.
3. Assert that the entry keys are exactly `command`, `enabled`, and `type`, and that no
   `environment` key exists.
4. Assert that `command == [ "pen-mcp-server" "--app" "desktop" ]`.
5. Assert that the entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
6. Assert that each off fixture has no module-owned `pencil` entry.
7. Assert that the rendered `.opencode/opencode.jsonc` uses `mcp.pencil`.
8. Assert that the unrelated setting and the differently named MCP entry stay unchanged.
9. Assert that a different final `pencil` value fails the evaluation. The evaluation fails through
   an option-merge conflict or the module assertion.
10. Assert that the `figma` case adds no `pencil` entry and the `pencil` case adds no
    `figma-ui-mcp` entry.

## Definition of done

- The OpenCode canonical entry runs the command array
  `[ "pen-mcp-server" "--app" "desktop" ]`.
- The entry has no `environment` field and keeps `type = "local"` and `enabled = true`.
- The fixtures exercise the new command and arguments together.
- The module fails evaluation for a different final `pencil` value.
- The module-local evaluation passes.
