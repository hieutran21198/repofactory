# Implementation plan: Expert role skill

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-write-skill-guide](task-write-skill-guide.md) | - |
| 2 | [task-write-role-template](task-write-role-template.md) | 1 |
| 3 | [task-write-role-builder-reference](task-write-role-builder-reference.md) | 1 |
| 4 | [task-link-solution-expert](task-link-solution-expert.md) | - |
| 5 | [task-add-eval-checks](task-add-eval-checks.md) | 1, 2, 3, 4 |
| 6 | [task-verify-generation](task-verify-generation.md) | 5 |

Task 1 makes the skill folder. Tasks 2 and 3 write into its `references/` folder. Task 4 is
independent of the skill files. Task 5 needs the three skill files and the changed solution
expert body, because its checks read them. Task 6 needs the checks to pass first.

All tasks touch one component, `services/factory`, and one context, `context-factory`.

## Definition of done

- The skill folder `_assets/agent/skill/by-role/solution-expert/expert-role/` has `SKILL.md`,
  `references/role-template.md`, and `references/role-builder.md` as `spec-skill-files`,
  `spec-role-template`, and `spec-role-builder-reference` give them.
- The three skill files name no file of the factory repository.
- The base body of the solution expert names the `expert-role` skill in the hand-off bullet of
  `## Mixture of experts`.
- The six checks of `spec-eval-checks` pass in `tests/eval.nix`.
- The skill renders in the skill folder of each harness in use, and the solution expert role
  file of each harness in use names the skill.
- An agent that reads only the rendered skill drafts a role body and a role declaration for a
  fictional component without a file outside a downstream project.
- The acceptance criteria of each requirement pass.
