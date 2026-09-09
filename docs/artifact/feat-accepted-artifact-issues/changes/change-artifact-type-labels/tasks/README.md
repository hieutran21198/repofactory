# Implementation plan: Artifact type labels

**Change:** [Show artifact types with labels](../README.md)

## Order

| Order | Task | Depends on |
| --- | --- | --- |
| 1 | [Add the managed label model](task-add-label-model.md) | - |
| 2 | [Add GitHub type labels](task-add-github-labels.md) | 1 |
| 3 | [Add Trello type labels](task-add-trello-labels.md) | 1 |
| 4 | [Check provider type labels](task-check-type-labels.md) | 2, 3 |

## Completion

- Each provider item has exactly one managed artifact type label.
- Synchronization preserves unrelated labels.
- Withdrawn items keep their artifact type label.
- Adapter tests and the synchronizer unit suite pass.
- The Nix module evaluation passes.
- The complete provider lifecycle passes for GitHub Projects and Trello.
