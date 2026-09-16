# task-canonical-roles: Update the canonical coordination roles

**Plan:** [Implementation plan](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation, spec-coordination-protocol, spec-phase-messages, spec-harness-delivery, spec-verification-contract, spec-release-role, spec-contract-driven, spec-interactive-recommend, spec-parallel-implementation
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This is the first task in the only changed context and aggregate.

## Goal

Make the canonical roles, role descriptions, and role skills use one coordination owner.

## Files

- `services/factory/composition/artifact-driven/_assets/agent/role/artifact-master/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/agent/role/requirement-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/agent/role/solution-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/agent/role/artifact-release-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/artifact-master/artifact-master/SKILL.md`
- `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/SKILL.md`
- `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/references/role-template.md`
- `services/factory/composition/artifact-driven/default.nix`
- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Make the artifact master own all expert spawning and coordination.
2. Keep phase content with the expert that owns each phase.
3. Prohibit each content expert from spawning or directly tasking another expert.
4. Keep specification, decision, and implementation-plan ownership with the solution expert.
5. Make the solution expert send feasibility-review and owner-selection requests to the
   artifact master.
6. Add the coordination envelope to the applicable artifact-master and solution-expert routes.
   Include `change`, `phase`, `source-owner`, `target-owner`, `component`, `input`,
   `expected-output`, and `commit-boundary`.
7. Keep the phase 2 contract payload complete. Include the review identifier, specification path,
   contract, context, aggregate, invariant, relation, and component.
8. Require each returned constraint to include its review identifier, constraint identifier,
   statement, evidence, affected item, and responsible owner.
9. Make each implementation expert return feasibility constraints only in phases 2 and 3.
10. Update the `expert-role` skill and its role template. Prohibit specification, decision, and
    task authorship in phases 2 and 3.
11. Keep phase 4 implementation ownership with each implementation expert.
12. Keep the phase 5 readiness gate with the solution expert.
13. Make the artifact master request readiness from the solution expert.
14. Make the artifact release expert return a missing-readiness query to the artifact master.
    Do not let it request readiness directly from the solution expert.
15. Route the phase 5 copy through the artifact master after readiness is `true`.
16. Make the artifact master batch phase 4 work from dependencies and each `can-parallel`
    answer.
17. Keep all phase 4 results in one commit.
18. Keep all current Plan-Pn, phase 4 start, progress, and handoff message fields.
19. Keep the current option interview and its mid-build approval gate.
20. State the OpenCode `allow`, explicit `deny`, and depth 1 declarations in the
    artifact-master body.
21. Tell the OpenCode user to select `artifact-master` as the primary agent.
22. Update each built-in role description to state its content or coordination boundary.
23. Keep the artifact-master skill as a thin loader. Add the primary-agent selection instruction.
24. Keep `expert-role` in the solution-expert body only as advice to the artifact master, if the
    body names the skill.
25. Update or replace each affected role-text and skill-text assertion in `eval.nix` in this task.
    Do not defer an assertion that depends on changed text.

## Check

1. Check that only the artifact master owns expert spawning and coordination.
2. Check that each content expert calls no subagent and directly tasks no expert.
3. Check that the feasibility envelope has all eight fields and the complete contract payload.
4. Check that each returned constraint has all six required fields.
5. Check that the expert-role skill and template prohibit specification, decision, and task
   authorship in phases 2 and 3.
6. Check that a missing-readiness query goes from the release expert to the artifact master.
7. Check that the artifact-master body names the declarations and primary-agent selection.
8. Check that the artifact-master skill loads the rendered role and names primary-agent
   selection.
9. Check that the phase messages and option interview keep all current contract fields.
10. Check that all affected Boolean assertions agree with the changed role and skill text.
11. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
