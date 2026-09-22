# task-verify-harness-mcp: Verify harness-owned MCP settings

**Plan:** [Implementation plan](README.md)
**Covers:** req-enable-flag, req-design-tool, spec-ux-design-option, spec-design-tool, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-composition-mcp-handoff
**can-parallel:** no
**Parallel reason:** This task verifies all earlier changes in the same context and aggregate.

## Goal

Check the complete MCP contract and the composition handoff with local and real evaluations.

## Files

- All files changed by the tasks in this plan.

This task creates no permanent source file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Run the five local file evaluations.
2. Use these evaluations only for their local assertions.
3. Do not use an evaluation stub as proof of real option merging.
4. Enter `devenv shell` to run the real module system.
5. Use `e2e/.devenv/bootstrap/bootstrapLib.nix` as evidence for the `lib.evalModules` path.
6. Render an active fixture that selects all three harnesses.
7. Add unrelated settings and a differently named MCP entry to the active fixture.
8. Compare `.mcp.json` with the canonical Claude value from version 1.0.0.
9. Compare `.opencode/opencode.jsonc` with the canonical OpenCode value from version 1.0.0.
10. Compare `.codex/config.toml` with the canonical Codex value from version 1.0.0.
11. Confirm that each unrelated setting and differently named MCP entry stays unchanged.
12. Add a temporary different same-name server value for each harness.
13. Confirm that each final-value assertion fails the real module evaluation.
14. Restore the temporary conflict inputs.
15. Render an off fixture with a selected Claude harness and the signal off.
16. Confirm that the off fixture emits no `.mcp.json` file.
17. Render the same off fixture from commit `f5b0946` in a temporary worktree.
18. Compare all off-fixture output files byte for byte.
19. Remove the temporary worktree, fixtures, conflict inputs, and rendered local files.
20. Run `git diff --check`.
21. Confirm that only the planned source files remain in the phase 4 diff.

## Check

Run these local commands:

1. `nix-instantiate --eval --strict services/factory/domain/design-tool/tests/eval.nix`
2. `nix-instantiate --eval --strict services/factory/domain/agent/harness/claude/tests/eval.nix`
3. `nix-instantiate --eval --strict services/factory/domain/agent/harness/opencode/tests/eval.nix`
4. `nix-instantiate --eval --strict services/factory/domain/agent/harness/codex/tests/eval.nix`
5. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`
6. `git diff --check`

All six commands must report no error. Then complete the real `devenv shell` render checks in the
steps above.
