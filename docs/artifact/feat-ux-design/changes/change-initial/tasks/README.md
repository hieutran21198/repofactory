# Implementation plan: UX Design

**Change:** [Initial](../../../changes/change-initial/README.md)

## Order of work

All tasks use `services/factory`, `context-factory`, and `agg-repository-blueprint`. Thus, phase 4
must do the tasks in sequence. The design-tool option is upstream from the composition. The
composition defines the conditional source and target paths before the content task supplies the
authored files. The evaluation task checks the completed output.

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-design-tool-option](task-design-tool-option.md) | none | no |
| 2 | [task-ux-design-composition](task-ux-design-composition.md) | task-design-tool-option | no |
| 3 | [task-design-template](task-design-template.md) | task-ux-design-composition | no |
| 4 | [task-ux-design-evals](task-ux-design-evals.md) | task-design-template | no |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-design-tool-option | task-ux-design-composition | Option dependency | The composition reads `domain.design-tool.use`. |
| task-ux-design-composition | task-design-template | Path contract | The composition defines the conditional role chapter paths and the Design template target. |
| task-design-template | task-ux-design-evals | Verification dependency | The evaluations inspect the final role bodies, chapters, template, and composition output. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-design-tool-option | The approved phase 3 plan is available. |
| 2 | task-ux-design-composition | Group 1 completes its option declaration. |
| 3 | task-design-template | Group 2 completes its conditional path wiring. |
| 4 | task-ux-design-evals | Group 3 supplies all authored sources. |

Each group has one task. No task can run in parallel because all tasks use the same component,
context, and aggregate.

## Feasibility resolutions

| Constraint | Resolution |
| --- | --- |
| UX-P3-01 | Keep `task-design-tool-option` unchanged. The module path, auto-discovery, enum, and default are feasible. |
| UX-P3-02-C1 | Emit Claude `mcpServers` in the project-root `.mcp.json`. Do not put it in `.claude/settings.json`. Keep the Claude work in `task-ux-design-composition` because that task owns cross-domain MCP output. |
| UX-P3-02-C2 | Put each UX Design `config.${namespace}.domain` addition in the existing agent composition block. Do not depend on a shallow merge of two factory keys in the evaluation stub. |
| UX-P3-02-C3, UX-P3-04-C1 | Add `harness.uses` and the three harness setting inputs to each enabled MCP fixture. Check only the selected harness output. |
| UX-P3-03-C1 | Emit the Design template as its own nested `files` key. Keep its source outside the always-copied template directory. Verify the nested target after a real shell render. |
| UX-P3-03-C2 | Load each body-only UX Design chapter with `builtins.pathExists`. Append it after the optional DDD chapter. Parse before the assets exist and evaluate after they exist. |
| UX-P3-04-C2 | Limit the Nix evaluation to key selection and values. Use a real `devenv shell` render to prove that unrelated harness settings remain. |
| UX-P3-04-C3 | Put the designer expert denial in `domain.agent.harness.opencode.settings.agent`, not in role frontmatter. |
| UX-P3-04-C4 | Keep the current off fixtures and exact comparisons unchanged. Add enabled fixtures instead of changing off expectations. |

## Requirement and specification coverage

| Artifact | Tasks |
| --- | --- |
| `req-enable-flag` | `task-ux-design-composition`, `task-ux-design-evals` |
| `req-design-tool` | `task-design-tool-option`, `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `req-phase-placement` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `req-designer-scope` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `req-ownership-boundary` | `task-design-template`, `task-ux-design-evals` |
| `req-parallel-workflow` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `req-design-output` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `spec-ux-design-option` | `task-ux-design-composition`, `task-ux-design-evals` |
| `spec-design-tool` | `task-design-tool-option`, `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `spec-phase-placement` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `spec-designer-expert` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `spec-design-ownership` | `task-design-template`, `task-ux-design-evals` |
| `spec-parallel-design` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |
| `spec-design-artifact` | `task-ux-design-composition`, `task-design-template`, `task-ux-design-evals` |

## Phase 4 commit boundary

Do not commit an individual task. Keep all source changes in one phase 4 commit after the final
evaluation passes. Do not commit rendered harness files or temporary negative-test changes.

## Definition of done

- The check of each task passes.
- The acceptance criteria of all seven requirements pass.
- The `use` option has only `unset` and `figma`, and its default is `unset`.
- The UX Design enable option defaults to `false` and renders no file by itself.
- The off output is byte-identical and contains no UX Design role, chapter, template, or MCP key.
- The on output contains the designer expert, conditional chapters, and the Design template.
- Claude receives `mcpServers` in `.mcp.json` when `use` is `figma`.
- OpenCode and Codex receive their applicable Figma MCP keys when `use` is `figma`.
- A real shell render preserves unrelated harness settings and the nested Design template target.
- The designer role and Design template enforce the scope, ownership, reuse, and output contracts.
- Phase 5 copies `design/` without a sixth phase.
- The complete artifact-driven composition evaluation passes.
- The artifact master puts all tracked phase 4 output in one commit.
