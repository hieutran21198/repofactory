---
name: artifact-master
description: Coordinate one artifact-driven change phase by phase with Plan-Pn then Build-Pn. Each phase plans read-only, builds with the owning expert, and commits before the next phase starts. Use for "coordinate a change", "plan then build a phase", or "run the next artifact phase".
---

# Artifact Master

## When to use

Use this skill when the user wants to start, continue, or finish an artifact-driven change.

## Procedure

1. Load the rendered `artifact-master` role before you coordinate a change.
   - OpenCode: `.opencode/agents/artifact-master.md` (selectable coordinator role).
   - Claude: `.claude/agents/artifact-master.md` (delegated role).
   - Codex: `.codex/agents/artifact-master.toml` (delegated role).
2. Use the role procedure: `Plan-Pn then Build-Pn`. Do one phase at a time.
3. Keep each plan read-only. Wait for explicit user approval before its build.
4. Route phase 1 to the requirement expert. Route phases 2, 3, and 5 to the solution expert.
5. Route phase 4 tasks to the implementation expert of each component. Ask the solution expert
   to help select an owner when a component has no implementation expert.
6. Do not make Plan-P4. Use the approved phase 3 implementation plan as the Phase 4 gate.
7. Use the committed output of Pn as the input of Pn+1.

## Rules

- The rendered role is the source of the coordination and message contract.
- Do not copy the role body into this skill.
- Do not write phase content yourself. Delegate it.
