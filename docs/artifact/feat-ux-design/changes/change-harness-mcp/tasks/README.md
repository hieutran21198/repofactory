# Implementation plan: UX Design harness MCP ownership

**Change:** [Harness owns each MCP setting](../../../changes/change-harness-mcp/README.md)

## Order of work

All tasks use `services/factory`, `context-factory`, and `agg-repository-blueprint`.
Thus, phase 4 must do the tasks in sequence.

The first task adds the shared activation signal. The next three tasks add one adapter for each
harness. The fifth task checks the passive design-tool selection. The sixth task moves MCP
ownership out of the composition. The last task checks the complete change with the real module
system.

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-harness-ux-design-signal](task-harness-ux-design-signal.md) | none | no |
| 2 | [task-claude-harness-mcp](task-claude-harness-mcp.md) | task-harness-ux-design-signal | no |
| 3 | [task-opencode-harness-mcp](task-opencode-harness-mcp.md) | task-claude-harness-mcp | no |
| 4 | [task-codex-harness-mcp](task-codex-harness-mcp.md) | task-opencode-harness-mcp | no |
| 5 | [task-design-tool-eval](task-design-tool-eval.md) | task-codex-harness-mcp | no |
| 6 | [task-composition-mcp-handoff](task-composition-mcp-handoff.md) | task-design-tool-eval | no |
| 7 | [task-verify-harness-mcp](task-verify-harness-mcp.md) | task-composition-mcp-handoff | no |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-harness-ux-design-signal | task-claude-harness-mcp | Activation input | The Claude adapter reads the internal signal. |
| task-claude-harness-mcp | task-opencode-harness-mcp | Work sequence | Both tasks change the same context and aggregate. |
| task-opencode-harness-mcp | task-codex-harness-mcp | Work sequence | Both tasks change the same context and aggregate. |
| task-codex-harness-mcp | task-design-tool-eval | Work sequence | Both tasks change the same context and aggregate. |
| task-design-tool-eval | task-composition-mcp-handoff | Selection check | The composition reads the checked passive selection. |
| task-composition-mcp-handoff | task-verify-harness-mcp | Verification input | The final task checks the completed ownership move. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-harness-ux-design-signal | The approved phase 3 plan is available. |
| 2 | task-claude-harness-mcp | Group 1 completes the shared signal. |
| 3 | task-opencode-harness-mcp | Group 2 completes the Claude adapter. |
| 4 | task-codex-harness-mcp | Group 3 completes the OpenCode adapter. |
| 5 | task-design-tool-eval | Group 4 completes the Codex adapter. |
| 6 | task-composition-mcp-handoff | Group 5 completes the design-tool evaluation. |
| 7 | task-verify-harness-mcp | Group 6 completes the composition handoff. |

Each group has one task. No task can run in parallel because all tasks use the same component,
context, and aggregate.

## Feasibility resolutions

| ID | Resolution |
| --- | --- |
| C-SIG-01 | Use `_utils.mkBoolOpt` with `default = false` and `internal = true`. Add no `config` or `files` value. Check that `config` is absent. |
| C-HM-08 | Render `.mcp.json` only when `mcp-servers` is not empty. Check a selected Claude harness with the signal off. |
| C-HM-09 | Gate the Claude entry with the activation inputs. Do not read `mcp-servers` in the entry gate. Gate the file separately. |
| C-HM-10 | Use the 1.0.0 Claude command, arguments, environment, and `copyMode = "copy"` values. |
| C-HM-11 | Compare each final merged `figma-ui-mcp` value with its canonical value. Do not rely on normal option merging for conflict failure. |
| C-HM-12 | Use the 1.0.0 OpenCode literal with `environment`. Keep the renderer and unrelated settings. Use no `mkForce`. |
| C-HM-13 | Add the Codex entry under the activation gate. Keep this definition outside the file gate that reads `codex.settings`. |
| C-HM-14 | Use the 1.0.0 Codex command, arguments, and environment values. Keep unrelated settings. |
| C-DT-06 | Use the real option builder and `lib.evalModules` to prove rejection of an unsupported value. |
| C-DT-07 | Inspect `designToolModule.options.factory.domain.design-tool`. Assert that it declares only `use` and has no `config`. |
| C-COMP-01 | Set the signal only in the `documentation.use == "artifact-driven"` block. Check the applicable and inapplicable configurations. |
| C-COMP-02 | Remove only MCP fixtures, MCP assertions, the design-tool import, and unused MCP local values. Keep all non-MCP UX Design checks. |
| C-VER-01 | Treat the five file evaluations as local checks. Use `devenv shell` and the real module system for merge, conflict, render, and byte comparisons. |
| C-VER-02 | Remove temporary conflict inputs, temporary fixtures, and rendered local files before the phase 4 commit. Do not commit an individual task. |

## Requirement and specification coverage

| Artifact | Tasks |
| --- | --- |
| `req-enable-flag` | `task-harness-ux-design-signal`, `task-composition-mcp-handoff`, `task-verify-harness-mcp` |
| `req-design-tool` | All tasks |
| `spec-ux-design-option` | `task-harness-ux-design-signal`, `task-composition-mcp-handoff`, `task-verify-harness-mcp` |
| `spec-design-tool` | `task-design-tool-eval`, `task-composition-mcp-handoff`, `task-verify-harness-mcp` |
| `spec-harness-mcp` | `task-harness-ux-design-signal`, `task-claude-harness-mcp`, `task-opencode-harness-mcp`, `task-codex-harness-mcp`, `task-composition-mcp-handoff`, `task-verify-harness-mcp` |

## Phase 4 commit boundary

Do not commit an individual task. Keep all phase 4 changes in one commit after all checks pass.
Do not commit temporary fixtures, conflict inputs, or rendered local files.

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-enable-flag` and `req-design-tool` pass.
- The internal harness signal is Boolean, internal, and off by default.
- Each selected harness adds the canonical server only when all three conditions are true.
- Each harness keeps unrelated settings and differently named MCP entries.
- Each active harness rejects a different value for `figma-ui-mcp`.
- The design-tool module declares only the passive `use` selection.
- The composition writes no harness MCP setting.
- The composition evaluation checks only the internal signal handoff for MCP ownership.
- The real module system renders the three canonical MCP files.
- The off output is byte-identical to the output at `f5b0946`.
- All module-local and composition evaluations pass.
