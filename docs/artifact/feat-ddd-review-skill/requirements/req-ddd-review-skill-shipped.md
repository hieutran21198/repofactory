# req-ddd-review-skill-shipped: Ship the shared skill

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

A project that selects artifact-driven documentation, DDD, and a repository architecture must get
the `ddd-review` skill in each harness in use.

## Acceptance criteria

- Given a generated DDD project with a selected repository architecture, when it uses Claude, then it has `.claude/skills/ddd-review/`.
- Given a generated DDD project with a selected repository architecture, when it uses Codex or OpenCode, then it has `.agents/skills/ddd-review/`.

## Notes

The skill is shared. It is not owned by one expert role.
