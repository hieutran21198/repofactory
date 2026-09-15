# task-artifact-release-expert: Add the artifact release expert

**Plan:** [Implementation plan](README.md)
**Covers:** req-release-role, req-expert-routing, req-harness-delivery, spec-release-role, spec-harness-delivery
**Context:** context-factory
**Aggregate:** agg-repository-blueprint
**Component:** `services/factory`
**Dependency:** none
**can-parallel:** no
**Parallel reason:** This task changes the same context and aggregate as the other tasks.

## Goal

Add one built-in artifact release expert with a deterministic phase 5 procedure and verification.

## Steps

1. Add the canonical `artifact-release-expert` role body.
2. Register the role through the existing built-in role interface.
3. Render the role as a content expert for OpenCode, Claude, and Codex.
4. Require a phase 5 request with the change, versions, source commit, readiness, and removed paths.
5. Define the copy, replacement, deletion, and `change-initial` operations in their required order.
6. Limit the feature README update to the current version, current artifact links, and version row.
7. Prohibit edits to copied artifacts and domain-driven design work.
8. Require a low-cost model or a script with verification.
9. Report each copied, replaced, and deleted path in the verification result.
10. Stop phase 5 before its commit when the result differs from the expected content.

## Verify

1. Check that the built-in role name is `artifact-release-expert` in each harness.
2. Check that OpenCode renders it as a subagent.
3. Check that Claude and Codex render it as delegated roles.
4. Check that the role permits only the specified phase 5 operations.
5. Check that the README procedure gives one deterministic update for each required field.
6. Check that copy verification occurs before the phase commit.
