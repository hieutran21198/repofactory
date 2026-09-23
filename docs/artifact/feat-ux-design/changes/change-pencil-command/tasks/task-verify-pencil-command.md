# task-verify-pencil-command: Verify the Pencil command

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-pencil-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-codex-pencil-command
**can-parallel:** no
**Parallel reason:** This task verifies all earlier changes in the same context and aggregate.

## Goal

Check the three canonical Pencil entries, the conflict failure, and the unchanged off output with
the local and real module systems.

## Scope

- All files changed by the tasks in this plan.

This task creates no permanent source file.

## Steps

1. Run the five local file evaluations.
2. Use these evaluations only for their local assertions. Do not use an evaluation stub as proof of
   real option merging.
3. Enter `devenv shell` at the repository root to run the real module system.
4. Use the repository-root generated `.devenv/bootstrap/bootstrapLib.nix`, or the `devenv shell`
   render itself, as evidence for the `lib.evalModules` path. Do not use the `e2e` devenv project
   as evidence for the factory modules.
5. Do each real render in a throwaway worktree with gitignored fixture inputs. Do not render into
   the working tree.
6. Render an active fixture with all three harnesses selected, UX Design on, and
   `use = "pencil"`.
7. Compare each rendered `pencil` entry with its exact canonical fields: the Claude three keys
   `command`, `args`, and `env` with no `type` key, the OpenCode command array with no
   `environment` field, and the Codex command and arguments with no `env` field.
8. Confirm that each entry contains no `url`, document path, repository path, remote endpoint, or
   filesystem permission.
9. Confirm that the active fixture adds no `figma-ui-mcp` entry.
10. Add a temporary different final `pencil` value for each harness.
11. Confirm that the real evaluation fails for each harness. A different leaf value fails through
    an option-merge conflict or the module assertion. The contract requires an evaluation error
    only.
12. Restore the temporary conflict inputs.
13. Render an off fixture with selected harnesses, `use = "pencil"`, and the signal off.
14. Confirm that the off fixture emits no Pencil entry and no module-owned MCP file.
15. Render the same off fixture from the pre-phase-4 commit (HEAD at the start of the phase-4
    build) in a throwaway worktree.
16. Compare all off-fixture output files byte for byte.
17. Confirm that the phase 4 diff adds no event mechanism and no check of tool availability or tool
    operations. It holds only the planned harness modules and local checks.
18. Remove the throwaway worktrees, fixtures, conflict inputs, and rendered local files. Restore
    each touched tracked path.
19. Confirm that `git status` and `git diff` show only the planned files.
20. Run `git diff --check`.

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
- The real module system renders the exact canonical `pen-mcp-server --app desktop` entry for each
  selected harness.
- Each active harness fails evaluation for a different final `pencil` value, through an
  option-merge conflict or the module assertion.
- The off output is byte-identical to the pre-phase-4 output.
- No event mechanism is added.
- No throwaway worktree, fixture, or rendered file remains. `git status` and `git diff` show only
  the planned files.
