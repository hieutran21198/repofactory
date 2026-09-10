# Implementation plan: Workflow watch path indentation

**Change:** [Fix workflow watch path indentation](../../../changes/change-workflow-watch-path-indent/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Fix generated watch path indentation](task-fix-watch-path-indentation.md) | - |

## Definition of done

- A custom watch path is in the same YAML list as the factory paths.
- The generated list item has six leading spaces.
- The workflow evaluation fails if the indentation changes.
