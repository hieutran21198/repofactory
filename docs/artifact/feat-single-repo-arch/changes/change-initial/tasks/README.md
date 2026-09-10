# Implementation plan: Single repository architecture

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-add-single-seeds](task-add-single-seeds.md) | - |
| 2 | [task-write-single-page](task-write-single-page.md) | 1 |
| 3 | [task-compose-single-guidance](task-compose-single-guidance.md) | 2 |
| 4 | [task-map-context-to-src](task-map-context-to-src.md) | - |
| 5 | [task-add-eval-checks](task-add-eval-checks.md) | 1, 3 |
| 6 | [task-verify-generation](task-verify-generation.md) | 5 |

## Definition of done

- The single repository module seeds the eight files of `spec-single-seed`.
- The composition emits the single-repository guidance variants only when `repo-arch.use` is
  `single`.
- The DDD assets give the home of a bounded context for both architectures.
- The module evaluation checks pass.
- The acceptance criteria of each requirement pass.
