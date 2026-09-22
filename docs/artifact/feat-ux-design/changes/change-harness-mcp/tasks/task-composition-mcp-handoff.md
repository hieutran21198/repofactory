# task-composition-mcp-handoff: Move MCP ownership out of the composition

**Plan:** [Implementation plan](README.md)
**Covers:** req-enable-flag, req-design-tool, spec-ux-design-option, spec-design-tool, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-design-tool-eval
**can-parallel:** no
**Parallel reason:** This task consumes the completed module contracts in the same context and aggregate.

## Goal

Make the artifact-driven composition set only the internal activation signal for MCP ownership.

## Files

- `services/factory/composition/artifact-driven/default.nix`
- `services/factory/composition/artifact-driven/tests/eval.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Set `domain.agent.harness.ux-design.enable` to the UX Design composition value.
2. Keep this handoff in the `documentation.use == "artifact-driven"` agent block.
3. Remove the composition-owned Figma MCP local-value block.
4. Remove the OpenCode MCP write site.
5. Remove the Codex MCP write site.
6. Remove the Claude `.mcp.json` write site.
7. Remove each unused MCP local value and harness-selection local value.
8. Remove the direct design-tool module import from the composition evaluation.
9. Remove only the composition MCP fixtures and MCP assertions.
10. Preserve the OpenCode `agent.explore.model` fixture and assertion.
11. Preserve the designer role assertion.
12. Preserve the designer task-permission denial assertion.
13. Preserve the Design template assertion.
14. Preserve all other non-MCP UX Design assertions.
15. Keep only the internal signal handoff in the composition MCP checks.
16. Check the handoff for an artifact-driven configuration.
17. Check that another documentation selection has no handoff.

## Check

1. Run `nix-instantiate --parse services/factory/composition/artifact-driven/default.nix`.
2. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
3. Confirm that the composition contains no `figma-ui-mcp` value.
4. Confirm that the composition writes no harness MCP setting.
5. Confirm that the enabled fixture sets the internal signal to `true`.
6. Confirm that the disabled fixture sets the internal signal to `false`.
7. Confirm that a non-artifact-driven fixture has no signal handoff.
8. Confirm that all non-MCP UX Design assertions pass.
