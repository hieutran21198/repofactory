# task-claude-pencil-command: Set the Claude Pencil MCP command

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-pencil-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This task is first, and all four tasks change the same component, context, and aggregate.

## Goal

Replace the Claude canonical Pencil entry with the exact three-key entry that runs
`pen-mcp-server --app desktop`, and update the local check fixtures.

## Scope

- `services/factory/domain/agent/harness/claude/default.nix`
- `services/factory/domain/agent/harness/claude/tests/eval.nix`

This task changes no other file.

## Steps

1. Keep the Pencil server name `pencil` and the activation gate unchanged.
2. Set the canonical Pencil entry to `command = "pen-mcp-server"`, `args = [ "--app" "desktop" ]`,
   and `env = { }`.
3. Remove the `type = "stdio"` key. The entry must have exactly the three keys `command`, `args`,
   and `env`.
4. Keep the merge point, the render path, the file gate, the `copyMode = "copy"` value, and the
   conflict assertion. Do not use `lib.mkForce`.
5. Update the fixture `canonicalPencilServer` to the same three keys and values.
6. Replace the exact-key assertion with the key set `args`, `command`, and `env`. Remove the stdio
   transport assertion.
7. Add an assertion that the entry has no `type` key.
8. Assert that `args == [ "--app" "desktop" ]` and `env == { }`. The fixtures must exercise the new
   `pen-mcp-server --app desktop` command and arguments together.
9. Keep the conflict fixture with a different leaf value of the new entry.
10. Keep the off cases, the rendered `.mcp.json` cases, the two-entry case, the differently named
    entry, the `figma` cases, and the no-forbidden-field assertions.
11. Do not add a check of tool availability or tool operations.
12. Do not add an event mechanism.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/agent/harness/claude/tests/eval.nix`.
2. Assert that the module adds the exact canonical entry when all three conditions are true.
3. Assert that the entry keys are exactly `args`, `command`, and `env`, and that no `type` key
   exists.
4. Assert that `command == "pen-mcp-server"` and `args == [ "--app" "desktop" ]`.
5. Assert that the entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
6. Assert that each off fixture has no module-owned `pencil` entry.
7. Assert that two MCP entries render in one `.mcp.json` file and a differently named entry stays
   unchanged.
8. Assert that a different final `pencil` value fails the evaluation. The evaluation fails through
   an option-merge conflict or the module assertion.
9. Assert that the `figma` case adds no `pencil` entry and the `pencil` case adds no
   `figma-ui-mcp` entry.

## Definition of done

- The Claude canonical entry has exactly the three keys `command`, `args`, and `env`.
- The entry runs `pen-mcp-server` with `--app desktop` and has no `type` key.
- The fixtures exercise the new command and arguments together.
- The module fails evaluation for a different final `pencil` value.
- The module-local evaluation passes.
