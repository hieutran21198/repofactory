# Implementation plan: Artifact versions

**Change:** [Initial](../../../changes/change-initial/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-move-templates](task-move-templates.md) | - |
| 2 | [task-rewrite-wiki-model](task-rewrite-wiki-model.md) | 1 |
| 3 | [task-update-roles](task-update-roles.md) | 1 |
| 4 | [task-update-expert-skill](task-update-expert-skill.md) | 1 |
| 5 | [task-update-guidance](task-update-guidance.md) | 1 |
| 6 | [task-sync-classifier](task-sync-classifier.md) | - |
| 7 | [task-e2e-fixtures](task-e2e-fixtures.md) | 6 |
| 8 | [task-eval-checks](task-eval-checks.md) | 1, 2, 3, 4, 5, 6 |
| 9 | [task-migrate-artifacts](task-migrate-artifacts.md) | 6, 8 |
| 10 | [task-verify-generation](task-verify-generation.md) | 1 to 9 |

All tasks are in `context-factory`.

- Tasks 1 to 6 and 8 touch `services/factory`. The factory expert does them. Task 4 also touches
  the live role bodies in `utils/agent/role/`.
- Task 7 touches `e2e/`. Task 9 touches `docs/artifact/`. Task 10 touches the generated files of
  this repository. No implementation expert covers these components. The solution expert wrote
  these tasks.

Task 1 comes before tasks 2 to 5, because these tasks name the template paths under
`templates/change/`. Task 6 comes before task 7, because the live check tests the synchronizer.
Task 8 comes after tasks 1 to 6, because its checks read the text that these tasks write. Task 9
comes after tasks 6 and 8, because the synchronizer and its checks must accept the new tree before
the tree changes. Task 10 is the last task.

## Commits

- Tasks 1 to 8 and 10 form one commit: `feat: version feature artifacts`.
- Task 9 lands in the same commit, or in the commit that directly follows it:
  `docs: migrate artifacts to changes and versions layout`. The two commits are adjacent, so that
  the synchronizer and the tree of `docs/artifact/` do not disagree on `main` for more than one
  commit.

## Tools

- `python3` is not in the root devenv shell. Run a Python test inside the `e2e/` devenv shell or
  with `nix-shell -p python3 --run "..."` from the repository root.
- A Nix check runs with `nix-instantiate --eval --strict <file>`.
- `markdownlint --config .markdownlint.yaml` is available inside the devenv shell.

## Specification coverage

| Specification | Tasks |
| --- | --- |
| spec-artifact-layout | task-move-templates, task-rewrite-wiki-model, task-migrate-artifacts |
| spec-wiki-model | task-rewrite-wiki-model, task-eval-checks |
| spec-template-tree | task-move-templates, task-eval-checks |
| spec-requirement-expert-role | task-update-roles |
| spec-solution-expert-role | task-update-roles |
| spec-expert-role-skill | task-update-expert-skill |
| spec-guidance-pages | task-update-guidance |
| spec-sync-classifier | task-sync-classifier |
| spec-e2e-fixtures | task-e2e-fixtures |
| spec-eval-checks | task-eval-checks, task-verify-generation |
| spec-migration | task-migrate-artifacts, task-verify-generation |

## Definition of done

- The check of each task passes.
- The acceptance criteria of each requirement pass.
- The generated files of this repository match their sources after `devenv shell`.
