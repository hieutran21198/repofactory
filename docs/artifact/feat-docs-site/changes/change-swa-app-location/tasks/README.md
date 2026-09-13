# Implementation plan: Documentation site

**Change:** [Point SWA app_location at build output](../../../changes/change-swa-app-location/README.md)

The code already exists through hotfix `9fc9e77`. The tasks confirm alignment between the code and the specifications. The tasks write no new code.

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-verify-workflow-renderer](task-verify-workflow-renderer.md) | - |
| 2 | [task-verify-pipeline-renderer](task-verify-pipeline-renderer.md) | - |
| 3 | [task-verify-eval-suite](task-verify-eval-suite.md) | 1, 2 |

Steps 1 and 2 are independent. Each task touches only `context-factory`. Step 3 runs last. It checks the full suite after steps 1 and 2 pass.

## Definition of done

- The check of each task passes.
- The acceptance criteria of each requirement pass.
- The full evaluation suite is green.
- The `github-pages` defaults stay unchanged.
