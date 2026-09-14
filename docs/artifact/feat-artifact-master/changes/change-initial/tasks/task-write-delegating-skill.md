# task-write-delegating-skill: Write the delegating skill

**Plan:** [Implementation plan](README.md)
**Covers:** req-harness-delivery, spec-harness-delivery
**Context:** context-factory

## Goal

Write a thin artifact-master skill that loads the rendered role for the harness in use.

## Files

- `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/artifact-master/artifact-master/SKILL.md`

## Steps

1. Keep the artifact-master skill frontmatter and use case.
2. List the rendered role path for OpenCode, Claude, and Codex.
3. Instruct the harness to load the rendered role before it coordinates a change.
4. Keep the phase order, routing, approval gate, and Phase 4 rule.
5. Remove any copy of the canonical role body from the skill.

## Check

Read the skill and check that it identifies all three paths without a copy of the role body.
