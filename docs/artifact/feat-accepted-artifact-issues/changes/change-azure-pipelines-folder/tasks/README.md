# Implementation plan: Accepted artifact issues

**Change:** [change-azure-pipelines-folder](../README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-azure-pipelines-folder-option](task-azure-pipelines-folder-option.md) | - |
| 2 | [task-azure-pipelines-folder-emission](task-azure-pipelines-folder-emission.md) | Step 1 |
| 3 | [task-check-azure-pipelines-folder](task-check-azure-pipelines-folder.md) | Steps 1 and 2 |

Step 1 adds the domain option and its validation. Step 2 uses the validated option in the composition.
Step 3 adds the evaluation checks. All tasks stay in `context-factory` and the `services/factory` component.

The domain option is upstream of the composition. The composition is upstream of its evaluation checks.

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-azure-pipelines-folder` pass.
- The default pipeline path is `azure-pipelines/accepted-artifact-issues.yml`.
- A valid custom folder emits `<folder>/accepted-artifact-issues.yml` with unchanged content.
- Each invalid folder stops evaluation before the factory emits a pipeline file.
- A folder option change does not change a GitHub Actions path or file.
