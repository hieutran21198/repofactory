# task-local-experts: Update the project-local expert text

**Plan:** [Implementation plan](README.md)
**Covers:** req-expert-routing, req-content-ownership, req-contract-driven-spec, req-harness-delivery, spec-coordination-protocol, spec-harness-delivery, spec-contract-driven
**Context:** context-factory
**Component:** `utils/agent`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** The plan puts this task after prior work because all tasks use the same context and aggregate.

## Goal

Make both tracked project-local role bodies use the constraints-only phase 2 and phase 3
boundary.

## Owner selection

The artifact master must select one owner before this task starts. The owner must change both
tracked role bodies together.

## Files

- `utils/agent/role/factory-expert/ROLE.md`
- `utils/agent/role/nix-lib-expert/ROLE.md`

## Steps

1. State that each implementation expert returns feasibility constraints only in phase 2.
2. State that each implementation expert returns task feasibility constraints only in phase 3.
3. Prohibit each implementation expert from authoring a specification, decision, or task.
4. State that each implementation expert calls no subagent and directly tasks no expert.
5. Route all expert coordination through the artifact master.
6. Keep phase 4 implementation ownership with the applicable expert.
7. Keep the component boundary of each expert unchanged.
8. Remove each instruction that tells an implementation expert to write a phase 2 or phase 3
   artifact.
9. Do not change or check the ignored `devenv.local.nix` descriptions.

## Check

1. Check both role bodies for the constraints-only phase 2 and phase 3 rule.
2. Check both role bodies for the prohibition on specification, decision, and task authorship.
3. Check both role bodies for the no-subagent and no-direct-task rule.
4. Check that `factory-expert` still owns phase 4 for `services/factory`.
5. Check that `nix-lib-expert` still owns phase 4 for `libs/nix`.
6. Check that neither expert receives coordination ownership.
7. Confirm that this task changes no ignored local file.
