# task-ux-design-evals: Verify UX Design composition

**Plan:** [Implementation plan](README.md)
**Covers:** req-enable-flag, req-design-tool, req-phase-placement, req-designer-scope, req-ownership-boundary, req-parallel-workflow, req-design-output, spec-ux-design-option, spec-design-tool, spec-phase-placement, spec-designer-expert, spec-design-ownership, spec-parallel-design, spec-design-artifact
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-design-template
**can-parallel:** no
**Parallel reason:** This task verifies the final output of all earlier tasks in the same component.

## Goal

Make the factory evaluation prove the enabled contract and the byte-identical disabled contract.

## Files

- `services/factory/composition/artifact-driven/tests/eval.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-designer-harness`
- `adr-design-artifact-placement`
- `adr-repository-blueprint-pattern`

## Steps

1. Add `uxDesign`, `use`, `harnessUses`, and per-harness setting inputs to the composition test module.
2. Write `domain.agent.harness.uses` and the supplied Claude, OpenCode, and Codex settings in each applicable fixture.
3. Keep existing off fixtures and their exact role and file comparisons unchanged.
4. Add enabled fixtures for DDD on and off.
5. Add `unset` and `figma` fixtures.
6. Add one selected-harness fixture for Claude, OpenCode, and Codex.
7. Check the `ux-design.enable` Boolean option and its `false` default.
8. Check the `domain.design-tool.use` enum values and `unset` default.
9. Check that the design-tool domain emits no file or harness setting.
10. Check that the disabled output has no designer role, designer permission, UX Design chapter,
   Design template, or MCP key.
11. Keep exact source and byte checks for all always-copied assets.
12. Check that enabled fixtures render `designer-expert` only for selected harnesses.
13. Check OpenCode subagent mode and declared task permission `deny` for the designer expert.
14. Read the designer denial from global OpenCode settings only.
15. Check equal designer instruction bodies across Claude, OpenCode, and Codex.
16. Check that DDD chapters precede UX Design chapters.
17. Check that base role bodies stay unchanged.
18. Check the artifact-master and solution-expert parallel workflow text.
19. Check the designer scope, input, reuse, ownership, and tool-fallback text.
20. Check the artifact-release-expert `design/` copy rule and the five-phase rule.
21. Check conditional Design template delivery and copy mode.
22. Check the title, key line, five ordered sections, and four required tables.
23. Check that the ownership and external-reference rules occur in the Design template.
24. Check that Claude `figma` output uses `.mcp.json` with `mcpServers`.
25. Check that OpenCode and Codex `figma` output uses only the selected harness-native MCP key.
26. Check that each MCP value names `figma-ui-mcp` and Figma Desktop.
27. Check that `unset` emits no MCP output and does not remove the Design artifact contract.
28. Do not claim that the evaluation stub proves unrelated-setting preservation.
29. Keep each evaluation result as a Boolean assertion.
30. Add each new assertion to the final returned result set.

## Check

1. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
2. Confirm that all Boolean assertions pass.
3. Make one UX Design assertion false in a temporary test input.
4. Confirm that the evaluation fails.
5. Restore the test input.
6. Run the complete evaluation again.
7. Confirm that the final evaluation passes.
8. Enter `devenv shell` and let the real module system render the selected harness files.
9. Confirm that `.mcp.json` contains Claude `mcpServers`.
10. Confirm that `.claude/settings.json` contains no Claude MCP declaration.
11. Confirm that `.opencode/opencode.jsonc` keeps the unrelated local agent models and adds `mcp`.
12. Confirm that `.codex/config.toml` keeps unrelated settings and adds `mcp_servers`.
13. Confirm that the nested Design template target exists after the parent template directory copy.
14. Do not commit the rendered harness files or local settings.
15. Run `git diff --check`.
16. Confirm that the phase 4 diff changes no always-copied asset.
