# Implementation plan: Pencil command

**Change:** [pencil-command](../../../changes/change-pencil-command/README.md)

## Order of work

All four tasks use `services/factory`, `context-factory`, and `agg-repository-blueprint`. Thus,
phase 4 must do the tasks in sequence.

The first three tasks replace the canonical Pencil command in one harness each. The last task
checks the complete change with the local and real module systems.

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-claude-pencil-command](task-claude-pencil-command.md) | none | no |
| 2 | [task-opencode-pencil-command](task-opencode-pencil-command.md) | task-claude-pencil-command | no |
| 3 | [task-codex-pencil-command](task-codex-pencil-command.md) | task-opencode-pencil-command | no |
| 4 | [task-verify-pencil-command](task-verify-pencil-command.md) | task-codex-pencil-command | no |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-claude-pencil-command | task-opencode-pencil-command | Work sequence | The three entries must change together, and both tasks change the same context and aggregate. |
| task-opencode-pencil-command | task-codex-pencil-command | Work sequence | The three entries must change together, and both tasks change the same context and aggregate. |
| task-codex-pencil-command | task-verify-pencil-command | Verification input | The final task checks the completed canonical entries. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-claude-pencil-command | The approved phase 3 plan is available. |
| 2 | task-opencode-pencil-command | Group 1 completes the Claude entry. |
| 3 | task-codex-pencil-command | Group 2 completes the OpenCode entry. |
| 4 | task-verify-pencil-command | Group 3 completes the Codex entry. |

Each group has one task. No task can run in parallel because all tasks use the same component,
context, and aggregate, and the three canonical entries must change together.

## Feasibility resolutions

The factory expert returned these task feasibility constraints. Each constraint has a resolution
in the task wording and the plan.

| ID | Resolution |
| --- | --- |
| C-P3-01 | The three harness edits are value-only. No option, default, type, or gate changes. |
| C-P3-02 | The module paths, merge points, and render paths stay unchanged. |
| C-P3-03 | Keep `can-parallel: no` for every task and the chain Claude, then OpenCode, then Codex, then verify. The artifact master keeps the sequential order and the one-commit boundary. |
| C-P3-04 | Claude keeps exactly the three keys `command`, `args`, and `env` with no `type` key. The fixture delta replaces the old command, the empty arguments, and the key set. The Figma fixtures and assertions stay untouched. |
| C-P3-05 | OpenCode changes the command array only. Keep `type = "local"`, `enabled = true`, and no `environment` field. |
| C-P3-06 | Codex keeps exactly the two keys `command` and `args` with no `env` field. |
| C-P3-07 | task-verify joins the five evaluations, `git diff --check`, and the real render in series. The real render runs in a throwaway worktree with a gitignored fixture. The worktree holds no `devenv.local.nix`, because the file is gitignored. Thus the divergent local `environment` and `env` values do not enter the render. The untracked rendered `.mcp.json` files stay out of the status and diff. Compare the off output byte for byte with the pre-phase-4 output. The conflict inputs must fail evaluation for each harness. |
| C-P3-08 | `spec-pencil-mcp` line 172 requires all four evaluation paths. The plan runs five: the four named paths and the design-tool path. Five paths include the four required paths. No specification change is necessary. |

## Requirement and specification coverage

| Artifact | Tasks |
| --- | --- |
| `req-design-tool` | All four tasks |
| `spec-pencil-mcp` | All four tasks |

The other specifications of the feature do not change. They stay at version 2.0.0 and keep their
existing coverage.

## Acceptance criterion coverage

| Criterion of `req-design-tool` | Tasks |
| --- | --- |
| `pencil` selects pen.dev through the MCP server named `pencil` on an open `.pen` document. | task-claude-pencil-command, task-opencode-pencil-command, task-codex-pencil-command, task-verify-pencil-command |
| `figma` keeps the existing behavior. | task-claude-pencil-command, task-opencode-pencil-command, task-codex-pencil-command, task-verify-pencil-command |
| `unset` still produces the full Design artifact. | task-verify-pencil-command confirms the off output stays byte-identical. |
| A selected but unavailable tool still produces the full Design artifact. | task-verify-pencil-command confirms that the diff adds no availability check. |
| A failed tool operation still produces the full Design artifact. | task-verify-pencil-command confirms that the diff adds no operation check. |

## Phase 4 commit boundary

Do not commit an individual task. Keep all phase 4 changes in one commit after all checks pass.
Do not commit temporary fixtures, conflict inputs, or rendered local files. Do the real renders in
throwaway worktrees. Restore each touched tracked path. Confirm that `git status` and `git diff`
show only the planned files. The phase 4 commit holds the three harness modules and the three
local checks only.

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-design-tool` pass.
- Each canonical Pencil entry uses `pen-mcp-server` with `--app desktop`.
- The Claude entry has exactly the three keys `command`, `args`, and `env`, with no `type` key.
- The OpenCode entry has no `environment` field. The Codex entry has no `env` field.
- Each entry contains no `url`, document path, repository path, remote endpoint, or filesystem
  permission.
- Each entry keeps the name `pencil` and the existing render path, merge point, and gate.
- The `figma` behavior stays unchanged.
- Each active harness rejects a different final `pencil` value.
- The off output is byte-identical to the pre-phase-4 output.
- The real module system renders the three canonical entries.
- No task adds an event mechanism.
- All local and composition evaluations pass.
- The artifact master puts all tracked phase 4 output in one commit.
