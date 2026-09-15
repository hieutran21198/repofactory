# Implementation plan: Documentation site

**Change:** [Add Static Web App deploy tool option](../../../changes/change-swa-deploy-tool-option/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-deploy-tool-option](task-deploy-tool-option.md) | - |
| 2 | [task-cli-render](task-cli-render.md) | Step 1 |
| 3 | [task-eval-docs](task-eval-docs.md) | Steps 1 and 2 |

The option contract must exist before the renderers use its value. The checks and the guide must match the completed renderers.

## Coverage

| Artifact | Tasks |
| --- | --- |
| `req-swa-deploy-tool` | `task-deploy-tool-option` |
| `req-swa-cli-pinned` | `task-cli-render` |
| `spec-swa-deploy-tool` | `task-deploy-tool-option`, `task-eval-docs` |
| `spec-swa-cli-deploy` | `task-cli-render`, `task-eval-docs` |

## Definition of done

- The check of each task passes.
- The acceptance criteria of `req-swa-deploy-tool` pass.
- The acceptance criteria of `req-swa-cli-pinned` pass.
- Each CI provider emits exactly one selected Static Web App deploy shape.
- The `github-pages` pipelines have no change.
- The guide asset and the canonical guide have the same content.
