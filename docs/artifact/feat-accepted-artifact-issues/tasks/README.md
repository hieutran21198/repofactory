# Implementation plan: Accepted artifact issues

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Define project-management options](task-project-options.md) | - |
| 2 | [Build the artifact synchronizer](task-artifact-synchronizer.md) | 1 |
| 3 | [Add the GitHub Projects adapter](task-github-projects.md) | 2 |
| 4 | [Add the Trello adapter](task-trello.md) | 2 |
| 5 | [Compose the generated integration](task-compose-integration.md) | 3, 4 |
| 6 | [Check the integration](task-check-integration.md) | 5 |

## Definition of done

- The check of each task passes.
- The acceptance criteria of each requirement pass.
- Each supported provider gets one idempotent issue tree from merged artifacts.
