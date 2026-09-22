# task-verify-pencil-design: Verify the Pencil design tool

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool, spec-pencil-mcp, spec-ux-design-option, spec-designer-expert
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-designer-expert-pencil
**can-parallel:** no
**Parallel reason:** This task verifies all earlier changes in the same context and aggregate.

## Goal

Check the complete Pencil contract, the composition handoff, and the off state with local and real
evaluations.

## Scope

- All files changed by the tasks in this plan.

This task creates no permanent source file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Run the five local file evaluations.
2. Use these evaluations only for their local assertions.
3. Do not use an evaluation stub as proof of real option merging.
4. Enter `devenv shell` at the repository root to run the real module system.
5. Use the repository-root generated `.devenv/bootstrap/bootstrapLib.nix`, or the `devenv shell`
   render itself, as evidence for the `lib.evalModules` path. Do not use the `e2e` devenv project
   as evidence for the factory modules.
6. Do each real render in a throwaway worktree with gitignored fixture inputs. Do not render into
   the working tree.
7. Render an active fixture with all three selected harnesses, UX Design on, and
   `use = "pencil"`.
8. Compare each rendered `pencil` entry with its exact canonical fields.
9. Confirm that each entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
10. Confirm that the active fixture adds no `figma-ui-mcp` entry.
11. Add an unrelated setting and a differently named MCP entry to the fixture.
12. Confirm that each unrelated setting and differently named entry stays unchanged.
13. Add a temporary different final `pencil` value for each harness.
14. Confirm that the real evaluation fails for each harness. A different leaf value fails through
    an option-merge conflict or the module assertion. The contract requires an evaluation error
    only.
15. Restore the temporary conflict inputs.
16. Render a `figma` fixture with UX Design on and all three harnesses selected.
17. Compare each rendered `figma-ui-mcp` entry with its canonical value from version 1.0.0.
18. Confirm that the `figma` fixture adds no `pencil` entry.
19. Render an off fixture with selected harnesses, `use = "pencil"`, and the signal off.
20. Confirm that the off fixture emits no Pencil entry and no module-owned MCP file.
21. Render the same off fixture from the pre-phase-4 commit (HEAD at the start of the phase-4
    build) in a throwaway worktree.
22. Compare all off-fixture output files byte for byte.
23. Confirm that the composition sets only the internal UX Design signal and writes no MCP
    setting.
24. Confirm that the designer expert in subagent mode, the OpenCode task-permission denial, the UX
    Design chapters, the Design template, and the five phases stay present in the `pencil`
    fixture.
25. Confirm that the phase 4 diff adds no event mechanism and holds only the planned module,
    evaluation, and role files. It does not edit `AGENTS.md`,
    `docs/wiki/documentation/artifact-driven/README.md`, or
    `docs/wiki/documentation/mixture-of-experts/README.md`.
26. Confirm that the phase 4 diff adds no check of tool availability or tool operations.
27. Remove the throwaway worktrees, fixtures, conflict inputs, and rendered local files. Restore
    each touched tracked path.
28. Confirm that `git status` and `git diff` show only the planned files.
29. Run `git diff --check`.

## Check

Run these local commands:

1. `nix-instantiate --eval --strict services/factory/domain/design-tool/tests/eval.nix`
2. `nix-instantiate --eval --strict services/factory/domain/agent/harness/claude/tests/eval.nix`
3. `nix-instantiate --eval --strict services/factory/domain/agent/harness/opencode/tests/eval.nix`
4. `nix-instantiate --eval --strict services/factory/domain/agent/harness/codex/tests/eval.nix`
5. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`
6. `git diff --check`
7. `git status --short` and `git diff --stat`

All seven commands must report no error. The status and diff must show only the planned files.
Then complete the real `devenv shell` render checks in the steps above.

## Definition of done

- Each of the five evaluation paths passes.
- The real module system renders the exact canonical `pencil` entry for each selected harness.
- Each active harness fails evaluation for a different final `pencil` value, through an
  option-merge conflict or the module assertion.
- The `figma` output stays unchanged and adds no `pencil` entry.
- The off output is byte-identical to the pre-phase-4 output.
- The composition sets only the internal signal.
- No event mechanism is added.
- No throwaway worktree, fixture, or rendered file remains. `git status` and `git diff` show only
  the planned files.
