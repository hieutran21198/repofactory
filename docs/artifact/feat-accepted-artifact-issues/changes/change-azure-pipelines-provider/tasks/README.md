# Implementation plan: Accepted artifact issues

**Change:** [change-azure-pipelines-provider](../README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-ci-provider-option](task-ci-provider-option.md) | - |
| 2 | [task-azure-pipeline-emission](task-azure-pipeline-emission.md) | Step 1 |
| 3 | [task-validation-guides-checks](task-validation-guides-checks.md) | Step 2 |

Step 1 adds the domain option. Step 2 adds the Azure branch of the composition. Step 3 adds validation, guides, and tests. All tasks stay in context-factory. Upstream work comes before downstream work.

## Definition of done

- The check of each task passes.
- The acceptance criteria of req-azure-pipelines-sync pass.
- GitHub Actions files keep their bytes for the same settings.
