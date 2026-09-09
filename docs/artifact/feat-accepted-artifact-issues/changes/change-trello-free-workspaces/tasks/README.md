# Implementation plan: Trello Free workspaces

**Change:** [Support Trello Free workspaces](../README.md)

## Order

| Order | Task | Depends on |
| --- | --- | --- |
| 1 | [Remove the Custom Fields dependency](task-remove-custom-fields.md) | - |
| 2 | [Check the Trello Free life cycle](task-check-trello-free.md) | 1 |

## Completion

- The adapter and synchronizer unit tests pass.
- The Nix module evaluation passes.
- Trello setup can reuse the existing board without Custom Fields.
- The complete Trello life cycle passes.
