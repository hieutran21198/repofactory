# task-canonical-governance: Update the canonical roles and skill

**Plan:** [Implementation plan](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation, spec-coordination-protocol, spec-phase-messages, spec-harness-delivery, spec-release-role, spec-contract-driven, spec-interactive-recommend, spec-parallel-implementation
**Context:** context-factory
**Aggregate:** agg-repository-blueprint
**Component:** `services/factory`
**Dependency:** task-artifact-release-expert
**can-parallel:** no
**Parallel reason:** This task consumes the new role and changes the same context and aggregate.

## Goal

Make the canonical roles and the artifact-master skill use the new governance contracts.

## Steps

1. Route phase 5 from the artifact master to the artifact release expert.
2. Remove each old instruction that routes phase 5 copy work to the solution expert.
3. Keep only the phase 5 readiness gate in the solution-expert role.
4. Keep the artifact master as the coordinator without phase-content ownership.
5. Add the complete Plan-Pn, phase 4 start, progress, and handoff message fields.
6. Keep the coordinate-plan in chat and keep the phase 3 execution plan in `tasks/`.
7. Add the option interview to the requirement-expert and solution-expert roles.
8. Add the mid-build approval gate to the artifact-master role.
9. Add the contract-first and feasibility review procedure to the solution-expert role.
10. Require phase 3 tasks to record their context, component, aggregate, dependency, and `can-parallel` answer.
11. Require phase 4 to make ordered work groups and keep one phase 4 commit.
12. Keep project-specific implementation experts outside the built-in role set.
13. Keep the artifact-master skill as a thin loader for the rendered coordinator role.
14. Update the skill route summary and all three harness role paths without copying the role body.

## Verify

1. Check that the solution expert owns phases 2 and 3, but does not own the phase 5 copy.
2. Check that phase 5 cannot start without the solution expert's readiness confirmation.
3. Check that each option interview has options, advantages, disadvantages, and one recommendation.
4. Check that each contract review has a constraint, evidence, owner, and resolution.
5. Check that phase 4 uses task dependencies and `can-parallel` answers.
6. Check that the skill loads the correct rendered role for OpenCode, Claude, and Codex.
7. Check that no canonical role or skill keeps the old phase 5 route.
