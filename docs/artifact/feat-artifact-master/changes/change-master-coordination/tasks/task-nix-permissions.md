# task-nix-permissions: Declare OpenCode coordination permissions

**Plan:** [Implementation plan](README.md)
**Covers:** req-expert-routing, req-harness-delivery, req-parallel-implementation, spec-coordination-protocol, spec-harness-delivery, spec-verification-contract, spec-parallel-implementation
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-canonical-roles
**can-parallel:** no
**Parallel reason:** The declarations must agree with the canonical roles in the same context and aggregate.

## Goal

Make the factory declare one OpenCode coordination owner without a nested declaration loss.

## Files

- `services/factory/composition/artifact-driven/default.nix`

## Steps

1. Keep `artifact-master` in OpenCode mode `all`.
2. Keep `requirement-expert`, `solution-expert`, and `artifact-release-expert` in OpenCode mode
   `subagent`.
3. Declare task permission `allow` for `artifact-master` in the global OpenCode settings.
4. Declare task permission `deny` for `requirement-expert`, `solution-expert`, and
   `artifact-release-expert` in the global OpenCode settings.
5. Remove the old task permission `allow` from `solution-expert`.
6. Set the global OpenCode `subagent_depth` to `1`.
7. Keep all task permissions under `harness.opencode.settings.agent.<role>.permission.task`.
8. Do not put a task permission in role frontmatter.
9. Use a complete nested literal in `mkCoordinatorRole` when the mode changes.
10. Preserve all nested harness declaration data in the coordinator result.
11. Do not add `recursiveUpdate` to the evaluation library stub.
12. Do not change `libs/nix`. This composition needs no shared helper.

## Check

1. Evaluate the artifact-driven composition for the single and multiple repository layouts.
2. Evaluate each layout with DDD on and off.
3. Inspect the result for artifact-master mode `all` and task permission `allow`.
4. Inspect the three built-in content experts for mode `subagent` and explicit task permission
   `deny`.
5. Confirm that no built-in content expert has an absent task permission.
6. Confirm that `subagent_depth` is `1`.
7. Confirm that global settings are the only task-permission source.
8. Confirm that `mkCoordinatorRole` keeps all nested declaration data.
9. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
