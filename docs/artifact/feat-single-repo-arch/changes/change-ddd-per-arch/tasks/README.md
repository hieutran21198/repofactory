# Implementation plan: DDD assets per architecture

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-split-ddd-assets](task-split-ddd-assets.md) | - |
| 2 | [task-split-composition-assets](task-split-composition-assets.md) | - |
| 3 | [task-update-eval-checks](task-update-eval-checks.md) | 1, 2 |
| 4 | [task-verify-generation](task-verify-generation.md) | 3 |

## Definition of done

- The DDD module emits the guide and the templates of the active architecture only.
- The composition emits the guidance, the DDD chapters, and the phase-mapping page of the
  active architecture only.
- No generated DDD file names the directory of the inactive architecture.
- The module evaluation checks pass.
- The master artifacts of the feature show the current state.
