# task-eval-checks: Add coordination contract assertions

**Plan:** [Implementation plan](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-moex-explanation, req-moex-nix-delivery, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation, spec-coordination-protocol, spec-phase-messages, spec-harness-delivery, spec-verification-contract, spec-moex-page, spec-moex-delivery, spec-release-role, spec-contract-driven, spec-interactive-recommend, spec-parallel-implementation
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-local-experts
**can-parallel:** no
**Parallel reason:** This task completes the checks after all tracked source changes in the same context and aggregate.

## Goal

Make the Nix evaluation reject each missing or conflicting coordination contract item.

## Files

- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Keep the canonical role-text and skill-text assertions from `task-canonical-roles`.
2. Keep the mixture-of-experts heading and event assertions from `task-moex-pages`.
3. Add the remaining Boolean assertions for the canonical coordination contract.
4. Check all current Plan-Pn, phase 4 start, progress, and handoff message fields.
5. Check the current option interview and mid-build approval gate.
6. Check the master-routed phase 5 readiness gate and artifact-release-expert route.
7. Check artifact-master mode `all`.
8. Check mode `subagent` for `requirement-expert`, `solution-expert`, and
   `artifact-release-expert`.
9. Read task permissions from `harness.opencode.settings.agent`.
10. Check task permission `allow` for `artifact-master`.
11. Check explicit task permission `deny` for each of the three built-in content experts.
12. Check the global `subagent_depth` value `1`.
13. Check that global settings are the only task-permission source.
14. Compare built-in role instruction bodies across OpenCode, Claude, and Codex.
15. Exclude harness frontmatter and other declaration data from each body comparison.
16. Check the artifact-master skill paths and primary-agent selection instruction.
17. Check the canonical mixture-of-experts page, both equal mirrors, and all five index links.
18. Check page delivery for the single and multiple layouts with DDD on and off.
19. Keep each result as a Boolean assertion.
20. Do not make an assertion that claims to prove OpenCode runtime behavior.
21. Do not inspect `devenv.local.nix` or the two project-local role bodies in this composition
    evaluation. Those roles are outside the factory-rendered built-in role set.

## Check

1. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
2. Confirm that all Boolean assertions pass.
3. Make one required assertion false in a temporary test input.
4. Confirm that the evaluation fails for the false assertion.
5. Restore the test input.
6. Run the complete evaluation again.
7. Confirm that the final evaluation passes.
