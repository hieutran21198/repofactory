# task-render-verify: Render and verify each harness

**Plan:** [Implementation plan](README.md)
**Covers:** req-expert-routing, req-harness-delivery, req-moex-nix-delivery, req-contract-driven-spec, req-parallel-implementation, spec-coordination-protocol, spec-harness-delivery, spec-verification-contract, spec-moex-delivery
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-eval-checks
**can-parallel:** no
**Parallel reason:** This final task consumes all changed sources and checks in the same context and aggregate.

## Goal

Render the local harness output and verify the complete repository blueprint.

## Files

This task adds no tracked file. It reads these ignored generated outputs:

- Rendered role files under `.opencode/agents/`, `.claude/agents/`, and `.codex/agents/`.
- Rendered artifact-master skill files for each harness in use.
- `.opencode/opencode.jsonc` and the applicable Claude and Codex harness configuration.
- The generated mixture-of-experts page.

## Steps

1. Start the configured development environment to regenerate the factory output.
2. Do not edit a generated role, skill, page, or harness configuration directly.
3. Inspect every rendered built-in role for OpenCode, Claude, and Codex.
4. Get the expected instruction body from `role.builder.<role>.instruction`.
5. Remove only the harness declaration from each rendered role. Compare the remaining body for
   exact equality with the expected instruction body.
6. Do not use a `builtins.match` pattern to compare a multiline role body. Its wildcard does not
   span newline characters.
7. Read OpenCode task permissions and `subagent_depth` from the rendered settings.
8. Assert `allow` for `artifact-master` in the settings.
9. Assert explicit `deny` for the three built-in content experts in the settings.
10. Assert `subagent_depth = 1` in the settings.
11. Inspect the rendered artifact-master skill for primary-agent selection.
12. For single and multiple layouts, compare the generated page with its layout mirror.
13. Repeat the page comparison with DDD on and off. All four comparisons must be equal.
14. Run the artifact-driven composition evaluation after rendering.
15. Run `git diff --check`.
16. Confirm that the generated outputs add nothing to the phase 4 commit.
17. Give the verification result to the artifact master. The artifact master makes the one phase
    4 commit from all tracked task results.

## Check

1. Confirm that each selected harness has every built-in role.
2. Confirm exact equality between each rendered role body and its `role.builder` instruction.
3. Confirm artifact-master mode `all` and task permission `allow` in rendered OpenCode settings.
4. Confirm mode `subagent` and explicit task permission `deny` for each built-in content expert.
5. Confirm rendered OpenCode `subagent_depth` value `1`.
6. Confirm that the rendered skill tells the user to select `artifact-master` as the primary
   OpenCode agent.
7. Confirm page equality for the single and multiple layouts with DDD on and off.
8. Confirm that the complete Nix evaluation and `git diff --check` pass.
9. Confirm that this task adds no tracked generated file.
