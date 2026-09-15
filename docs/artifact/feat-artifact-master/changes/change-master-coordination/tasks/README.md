# Implementation plan: Artifact master

**Change:** [Master coordination](../../../changes/change-master-coordination/README.md)

## Order of work

All tasks use `context-factory` and `agg-repository-blueprint`. Thus, phase 4 must do the tasks
in sequence. The `Depends on` field records an output dependency. The step order also records
the required sequence for the shared context and aggregate.

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-canonical-roles](task-canonical-roles.md) | none |
| 2 | [task-nix-permissions](task-nix-permissions.md) | task-canonical-roles |
| 3 | [task-moex-pages](task-moex-pages.md) | task-nix-permissions |
| 4 | [task-local-experts](task-local-experts.md) | none |
| 5 | [task-eval-checks](task-eval-checks.md) | task-local-experts |
| 6 | [task-render-verify](task-render-verify.md) | task-eval-checks |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-canonical-roles | task-nix-permissions | Agreement dependency | The declarations must agree with the canonical role boundaries. |
| task-nix-permissions | task-moex-pages | Output dependency | The page must explain the final OpenCode declarations. |
| task-moex-pages | task-local-experts | Sequence only | Both tasks use the same context and aggregate. The local role text does not consume the page output. |
| task-local-experts | task-eval-checks | Output dependency | The final evaluation runs after all tracked source changes. |
| task-eval-checks | task-render-verify | Output dependency | The final render uses sources and checks that pass. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-canonical-roles | The approved phase 3 plan is available. |
| 2 | task-nix-permissions | Group 1 passes its check. |
| 3 | task-moex-pages | Group 2 passes its check. |
| 4 | task-local-experts | Group 3 passes its check. |
| 5 | task-eval-checks | Group 4 passes its check. |
| 6 | task-render-verify | Group 5 passes its check. |

Each group has one task. No task can run in parallel. All tasks use the same context and
aggregate.

## Feasibility resolutions

| Constraint | Resolution |
| --- | --- |
| `devenv.local.nix` is an ignored local file. | Do not change or check its two role descriptions. Change only the two tracked role bodies in `task-local-experts`. |
| The evaluation library stub has no `recursiveUpdate`. | Use a complete nested literal in `mkCoordinatorRole`. Do not change the stub or `libs/nix`. |
| Canonical role text and its current assertions must agree. | Update each affected assertion in `task-canonical-roles`. `task-nix-permissions` runs the evaluation next. |
| The OpenCode deny scope must be explicit. | Deny the three built-in content experts that the composition renders: `requirement-expert`, `solution-expert`, and `artifact-release-expert`. |
| The two project-local experts are outside the composition role set. | Put their no-subagent rule in each tracked role body. Do not add composition assertions for them. |
| Rendered harness files are ignored. | Use them only for verification. They add no file to the phase 4 commit. |
| `libs/nix` needs no helper change. | Do not make a `libs/nix` task. |

## Owner selection

The artifact master must select one owner for `task-moex-pages`. The owner must change the
canonical page, both factory mirrors, and the applicable checks together.

The artifact master must select one owner for `task-local-experts`. The owner must change both
tracked project-local role bodies together.

Do not split either task between owners.

## Specification coverage

| Specification | Tasks |
| --- | --- |
| spec-coordination-protocol | task-canonical-roles, task-nix-permissions, task-moex-pages, task-local-experts, task-eval-checks, task-render-verify |
| spec-phase-messages | task-canonical-roles, task-eval-checks |
| spec-harness-delivery | task-canonical-roles, task-nix-permissions, task-local-experts, task-eval-checks, task-render-verify |
| spec-verification-contract | task-canonical-roles, task-moex-pages, task-eval-checks, task-render-verify |
| spec-moex-page | task-moex-pages, task-eval-checks |
| spec-moex-delivery | task-moex-pages, task-eval-checks, task-render-verify |
| spec-release-role | task-canonical-roles, task-eval-checks |
| spec-contract-driven | task-canonical-roles, task-local-experts, task-eval-checks |
| spec-interactive-recommend | task-canonical-roles, task-eval-checks |
| spec-parallel-implementation | task-canonical-roles, task-nix-permissions, task-moex-pages, task-eval-checks |

## Phase 4 commit boundary

Do not commit an individual task. The rendered harness files are ignored and add nothing to the
commit. After all checks pass, the artifact master makes the one phase 4 commit from all tracked
task results.

## Definition of done

- The check of each task passes.
- The acceptance criteria of each covered requirement pass.
- The artifact master owns all expert spawning and coordination.
- The solution expert calls no subagent.
- The rendered OpenCode config declares the required modes, permissions, and depth.
- The canonical page and both repository-layout mirrors have equal content.
- OpenCode, Claude, and Codex receive equal instruction bodies for each built-in role.
- The two project-local role bodies use the constraints-only boundary.
- The artifact master puts all tracked phase 4 output in one commit.
