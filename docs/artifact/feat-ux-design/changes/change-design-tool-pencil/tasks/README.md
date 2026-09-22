# Implementation plan: Design tool Pencil

**Change:** [design-tool-pencil](../../../changes/change-design-tool-pencil/README.md)

## Order of work

All tasks use `services/factory`, `context-factory`, and `agg-repository-blueprint`. Thus, phase 4
must do the tasks in sequence.

The first task adds the `pencil` value to the design-tool selection. The next three tasks add one
Pencil MCP entry for each harness. The fifth task updates the designer expert contract and the
composition checks. The last task checks the complete change with the real module system.

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-design-tool-pencil-enum](task-design-tool-pencil-enum.md) | none | no |
| 2 | [task-claude-harness-pencil](task-claude-harness-pencil.md) | task-design-tool-pencil-enum | no |
| 3 | [task-opencode-harness-pencil](task-opencode-harness-pencil.md) | task-claude-harness-pencil | no |
| 4 | [task-codex-harness-pencil](task-codex-harness-pencil.md) | task-opencode-harness-pencil | no |
| 5 | [task-designer-expert-pencil](task-designer-expert-pencil.md) | task-codex-harness-pencil | no |
| 6 | [task-verify-pencil-design](task-verify-pencil-design.md) | task-designer-expert-pencil | no |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-design-tool-pencil-enum | task-claude-harness-pencil | Gate input | The Claude adapter gate reads `domain.design-tool.use == "pencil"`. |
| task-claude-harness-pencil | task-opencode-harness-pencil | Work sequence | Both tasks change the same context and aggregate. |
| task-opencode-harness-pencil | task-codex-harness-pencil | Work sequence | Both tasks change the same context and aggregate. |
| task-codex-harness-pencil | task-designer-expert-pencil | Contract input | The designer contract names the `pencil` MCP entry that the adapter tasks supply. |
| task-designer-expert-pencil | task-verify-pencil-design | Verification input | The final task checks the completed role, composition, and adapter contracts. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-design-tool-pencil-enum | The approved phase 3 plan is available. |
| 2 | task-claude-harness-pencil | Group 1 adds the `pencil` value. |
| 3 | task-opencode-harness-pencil | Group 2 completes the Claude entry. |
| 4 | task-codex-harness-pencil | Group 3 completes the OpenCode entry. |
| 5 | task-designer-expert-pencil | Group 4 completes the Codex entry. |
| 6 | task-verify-pencil-design | Group 5 completes the role and composition contract. |

Each group has one task. No task can run in parallel because all tasks use the same component,
context, and aggregate.

## Feasibility resolutions

The factory expert returned five task feasibility constraints. Each constraint has a resolution in
the task wording.

| ID | Resolution |
| --- | --- |
| C-P3-01 | Use the repository-root generated `.devenv/bootstrap/bootstrapLib.nix`, or the `devenv shell` render itself, as the `lib.evalModules` evidence. Do not use the `e2e` devenv project. |
| C-P3-02 | Name the byte-comparison base as the pre-phase-4 commit (HEAD at the start of the phase-4 build). Phase 3 is documentation only. |
| C-P3-03 | Expect the real evaluation to fail for a different leaf `pencil` value through an option-merge conflict or the module assertion. The contract requires an evaluation error only. |
| C-P3-04 | Keep the matched substrings of the unchanged assertions. Use whole-string, case-sensitive patterns with a leading and a trailing `.*` and escape each metacharacter, including the dot in `.pen`. |
| C-P3-05 | Run the real renders in throwaway worktrees with gitignored fixtures. Restore each touched tracked path. Confirm that `git status` and `git diff` show only the planned files. |

Convention alignment: the task files use `**Plan:**` only. The `**Change:**` line appears only in
this plan README, as in `change-harness-mcp`.

## Requirement and specification coverage

| Artifact | Tasks |
| --- | --- |
| `req-design-tool` | All tasks |
| `spec-design-tool` | task-design-tool-pencil-enum, task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-verify-pencil-design |
| `spec-pencil-mcp` | task-design-tool-pencil-enum, task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-designer-expert-pencil, task-verify-pencil-design |
| `spec-ux-design-option` | task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-designer-expert-pencil, task-verify-pencil-design |
| `spec-designer-expert` | task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-designer-expert-pencil, task-verify-pencil-design |

The other specifications of the feature do not change. They stay at version 1.0.0 and keep their
existing coverage.

## Acceptance criterion coverage

| Criterion of `req-design-tool` | Tasks |
| --- | --- |
| `pencil` selects pen.dev through the MCP server named `pencil` on an open `.pen` document. | task-design-tool-pencil-enum, task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-designer-expert-pencil, task-verify-pencil-design |
| `figma` keeps the existing behavior. | task-claude-harness-pencil, task-opencode-harness-pencil, task-codex-harness-pencil, task-designer-expert-pencil, task-verify-pencil-design |
| `unset` still produces the full Design artifact. | task-designer-expert-pencil, task-verify-pencil-design |
| A selected but unavailable tool still produces the full Design artifact. | task-designer-expert-pencil, task-verify-pencil-design |
| A failed tool operation still produces the full Design artifact. | task-designer-expert-pencil, task-verify-pencil-design |

## Phase 4 commit boundary

Do not commit an individual task. Keep all phase 4 changes in one commit after all checks pass.
Do not commit temporary fixtures, conflict inputs, or rendered local files. Do the real renders in
throwaway worktrees. Restore each touched tracked path. Confirm that `git status` and `git diff`
show only the planned files. The phase 4 commit holds the planned module, evaluation, and role
files only.

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-design-tool` pass.
- The permitted `use` values are `unset`, `figma`, and `pencil`, and the default is `unset`.
- The design-tool module declares only `use` and emits no file and no MCP setting.
- Each selected harness adds its exact canonical `pencil` entry only when the harness is selected,
  UX Design is on, and `use` is `pencil`.
- Each selected harness keeps the `figma` behavior unchanged and adds no `pencil` entry for
  `figma`.
- Each selected harness preserves unrelated settings and MCP entries with different names.
- Each active harness rejects a different final `pencil` value.
- Each Pencil entry contains no `url`, document path, repository path, remote endpoint, or
  filesystem permission.
- The composition sets only the internal UX Design signal and writes no MCP setting.
- The designer expert accepts `unset`, `figma`, and `pencil`, and produces the full Design artifact
  without the tool.
- The off output is byte-identical to the pre-phase-4 output.
- The real module system renders the three canonical Pencil entries.
- No task adds an event mechanism.
- All module-local and composition evaluations pass.
- The artifact master puts all tracked phase 4 output in one commit.
