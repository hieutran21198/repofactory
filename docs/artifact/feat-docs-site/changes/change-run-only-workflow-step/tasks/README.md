# Implementation plan: Run-only workflow steps

**Change:** [Fix run-only workflow steps](../../../changes/change-run-only-workflow-step/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Fix optional workflow step fields](task-fix-optional-step-fields.md) | - |

## Definition of done

- A `run`-only step evaluates and renders without a `uses` value.
- A `uses`-only step evaluates and renders without a `run` value.
- Invalid step combinations still fail.
- The existing evaluation checks pass.
