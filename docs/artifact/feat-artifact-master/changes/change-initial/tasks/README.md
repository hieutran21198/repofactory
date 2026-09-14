# Implementation plan: Artifact master

**Change:** [Initial](../../../changes/change-initial/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-write-canonical-role](task-write-canonical-role.md) | - |
| 2 | [task-write-delegating-skill](task-write-delegating-skill.md) | 1 |
| 3 | [task-add-composition-checks](task-add-composition-checks.md) | 1, 2 |

All tasks change `services/factory` in `context-factory`.

## Definition of done

- The canonical role controls one change and gives all required phase messages.
- The skill loads the rendered role without a copy of the role body.
- The composition evaluation checks the source role, the skill, and rendered harness roles.
- The artifact-driven composition evaluation passes.
