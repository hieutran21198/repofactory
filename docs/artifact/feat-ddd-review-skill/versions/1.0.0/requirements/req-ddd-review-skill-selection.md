# req-ddd-review-skill-selection: Ship only with DDD guidance

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The factory must ship the `ddd-review` skill only when the project selects artifact-driven
documentation, DDD, and either the single or multiple repository architecture.

## Acceptance criteria

- Given a project without artifact-driven documentation, when the factory renders it, then it has no `ddd-review` skill.
- Given a project without DDD, when the factory renders it, then it has no `ddd-review` skill.
- Given a project without a repository architecture, when the factory renders it, then it has no `ddd-review` skill.

## Notes

The skill depends on DDD guidance that is selected by the repository architecture.
