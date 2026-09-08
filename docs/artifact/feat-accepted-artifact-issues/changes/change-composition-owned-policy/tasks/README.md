# Implementation plan: Composition-owned artifact policy

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Move the composition policy](task-move-composition-policy.md) | - |
| 2 | [Check activation and validation](task-check-composition-policy.md) | 1 |

## Definition of done

- The provider domain selects an adapter and keeps adapter target and credential options.
- The artifact-driven project-issues composition owns `enable` and `artifact-status`.
- Adapter selection alone does not generate integration files or require complete adapter values.
- An enabled invalid composition stops Nix evaluation with a clear assertion.
- The master artifacts show the corrected interface.
- All module, synchronizer, workflow, and repository checks pass.
