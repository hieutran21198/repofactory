# Implementation plan: Documentation site

**Change:** [Azure Pipelines folder for the docs-site pipeline](../../../changes/change-azure-pipelines-folder/README.md)

## Order of work

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-use-azure-pipelines-folder](task-use-azure-pipelines-folder.md) | - | no |
| 2 | [task-check-azure-pipelines-folder](task-check-azure-pipelines-folder.md) | Step 1 | no |

Both tasks touch `services/factory`, `context-factory`, and
`agg-repository-blueprint`. Thus, the tasks run in sequence. The second task
checks the renderer and the file emission from the first task.

## Dependency graph

`task-use-azure-pipelines-folder` -> `task-check-azure-pipelines-folder`

## Parallel groups

| Task | can-parallel | Reason |
| --- | --- | --- |
| `task-use-azure-pipelines-folder` | no | The evaluation checks depend on its renderer and file emission changes. |
| `task-check-azure-pipelines-folder` | no | It depends on `task-use-azure-pipelines-folder` and touches the same context and aggregate. |

No tasks can run in parallel.

## Ordered batches

| Batch | Tasks | Start condition |
| --- | --- | --- |
| 1 | `task-use-azure-pipelines-folder` | None. |
| 2 | `task-check-azure-pipelines-folder` | Batch 1 is complete. |

## Coverage

| Artifact | Tasks |
| --- | --- |
| `req-docs-site-azure-pipelines-folder` | `task-use-azure-pipelines-folder`, `task-check-azure-pipelines-folder` |
| `spec-docs-site-files` | `task-use-azure-pipelines-folder`, `task-check-azure-pipelines-folder` |
| `spec-docs-site-azure-pipeline` | `task-use-azure-pipelines-folder`, `task-check-azure-pipelines-folder` |
| `spec-azure-static-web-app` | `task-use-azure-pipelines-folder`, `task-check-azure-pipelines-folder` |
| `spec-eval-checks` | `task-check-azure-pipelines-folder` |

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-docs-site-azure-pipelines-folder` pass.
- The default and custom Azure Pipelines folder checks pass.
- The Azure Pipelines provider domain rejects each invalid folder value.
- A folder change changes only the Azure pipeline path and its trigger self-path.
- The GitHub Actions paths and bytes do not change.
- The generated user guide does not change.
