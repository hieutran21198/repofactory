# Implementation plan: Workflow step scalars

**Change:** [Accept workflow step scalars](../../../changes/change-workflow-step-scalars/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Accept scalar map values](task-accept-scalar-map-values.md) | - |

## Definition of done

- `with` and `env` accept strings, Booleans, integers, and floating-point numbers.
- The renderer keeps each scalar type in generated YAML.
- A LaTeX action with `latexmk_use_xelatex = true` evaluates and renders.
- Lists and attribute sets remain invalid map values.
