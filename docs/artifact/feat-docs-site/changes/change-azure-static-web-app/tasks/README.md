# Implementation plan: Documentation site

**Change:** [Add Azure Static Web App publication target](../../../changes/change-azure-static-web-app/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-target-options](task-target-options.md) | - |
| 2 | [task-workflow-renderer](task-workflow-renderer.md) | Step 1 |
| 3 | [task-azure-pipeline-renderer](task-azure-pipeline-renderer.md) | Step 1 |
| 4 | [task-eval-checks](task-eval-checks.md) | Steps 1, 2, 3 |
| 5 | [task-user-guide](task-user-guide.md) | Steps 2, 3 |

Steps 2 and 3 share the contract from step 1. Do step 2 and step 3 in any order after step 1. Do step 4 after steps 1, 2, and 3. Do step 5 after steps 2 and 3.

## Definition of done

- The check of each task passes.
- The acceptance criteria of each requirement pass.
