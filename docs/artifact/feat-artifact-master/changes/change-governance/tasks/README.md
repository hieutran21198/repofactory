# Implementation plan: Artifact master

**Change:** [Governance](../../../changes/change-governance/README.md)

## Order of work

All tasks change `context-factory`. Thus, phase 4 must do the tasks in sequence.

| Step | Task | Dependency |
| --- | --- | --- |
| 1 | [task-artifact-release-expert](task-artifact-release-expert.md) | none |
| 2 | [task-canonical-governance](task-canonical-governance.md) | task-artifact-release-expert |
| 3 | [task-templates](task-templates.md) | task-canonical-governance |
| 4 | [task-wiki-governance](task-wiki-governance.md) | task-templates |
| 5 | [task-nix-evaluation](task-nix-evaluation.md) | task-wiki-governance |

## Dependency graph

| Upstream task | Downstream task | Reason |
| --- | --- | --- |
| task-artifact-release-expert | task-canonical-governance | The phase routes need the new content expert. |
| task-canonical-governance | task-templates | The templates must agree with the phase 3 role contract. |
| task-templates | task-wiki-governance | The parallel-work explanation must agree with the task fields. |
| task-wiki-governance | task-nix-evaluation | The final checks consume all role, skill, template, and page outputs. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-artifact-release-expert | The approved phase 3 plan is available. |
| 2 | task-canonical-governance | Group 1 passes its checks. |
| 3 | task-templates | Group 2 passes its checks. |
| 4 | task-wiki-governance | Group 3 passes its checks. |
| 5 | task-nix-evaluation | Group 4 passes its checks. |

Each group has one task. No task can run in parallel because all tasks change `context-factory`.

## Phase 4 commit boundary

Do not commit an individual task. Join all task outputs after all checks pass. Keep all phase 4
output in one commit.

## Definition of done

- The check of each task passes.
- The acceptance criteria of each covered requirement pass.
- Open feasibility assumptions have repository evidence or an artifact correction.
- OpenCode, Claude, and Codex receive the required built-in roles.
- The canonical page and its repository-layout mirrors are equal.
- The phase 4 output is in one commit.
