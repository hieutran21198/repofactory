# Implementation plan: DDD review skill

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-write-ddd-review-skill](task-write-ddd-review-skill.md) | - |
| 2 | [task-register-ddd-review-skill](task-register-ddd-review-skill.md) | 1 |
| 3 | [task-add-ddd-review-checks](task-add-ddd-review-checks.md) | 1, 2 |
| 4 | [task-verify-ddd-review-skill](task-verify-ddd-review-skill.md) | 3 |

All tasks touch `services/factory` in `context-factory`.

## Definition of done

- The shared `ddd-review` skill has the frontmatter and review procedure in
  `spec-ddd-review-skill-content`.
- The composition registers the skill only for an artifact-driven DDD project with a repository
  architecture.
- The evaluation checks cover registration, omission, and required skill content.
- The composition evaluation passes.
- A generated single and multiple repository project render the skill in each selected harness.
