# Implementation plan: DDD design

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-add-design-domain](task-add-design-domain.md) | - |
| 2 | [task-write-ddd-guidance](task-write-ddd-guidance.md) | 1 |
| 3 | [task-write-domain-templates](task-write-domain-templates.md) | 1 |
| 4 | [task-add-ddd-seeds](task-add-ddd-seeds.md) | 3 |
| 5 | [task-extend-roles](task-extend-roles.md) | 1 |
| 6 | [task-compose-ddd-guidance](task-compose-ddd-guidance.md) | 2, 5 |
| 7 | [task-add-eval-checks](task-add-eval-checks.md) | 4, 6 |
| 8 | [task-verify-generation](task-verify-generation.md) | 7 |

## Definition of done

- The `design.use` option exists and accepts `unset` and `ddd`.
- The DDD module emits the design guide, the templates, and the seeds with the copy modes of
  `spec-ddd-files`.
- The roles get the DDD chapter only when `design.use` is `ddd`.
- The composition emits the DDD guidance variants and the phase-mapping page only when
  `design.use` is `ddd`.
- The module evaluation checks pass.
- The acceptance criteria of each requirement pass.
