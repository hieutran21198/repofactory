# task-ux-design-composition: Compose optional UX Design

**Plan:** [Implementation plan](README.md)
**Covers:** req-enable-flag, req-design-tool, req-phase-placement, req-designer-scope, req-parallel-workflow, req-design-output, spec-ux-design-option, spec-design-tool, spec-phase-placement, spec-designer-expert, spec-parallel-design, spec-design-artifact
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-design-tool-option
**can-parallel:** no
**Parallel reason:** This task consumes the design-tool option and changes the shared composition.

## Goal

Add UX Design through one enable-gated composition without changing the disabled output.

## Files

- `services/factory/composition/artifact-driven/default.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-designer-harness`
- `adr-design-artifact-placement`
- `adr-repository-blueprint-pattern`

## Steps

1. Declare `composition.artifact-driven.ux-design.enable` with `_utils.mkBoolOpt`.
2. Set the default to `false` and attach no file to the option declaration.
3. Read `domain.design-tool.use` as `use` without adding a second name.
4. Put each UX Design `config.${namespace}.domain` addition in the existing agent composition block.
5. Add enable-gated domain values with `lib.optionalAttrs` inside that existing block.
6. Keep the existing artifact-driven documentation gate.
7. Extend `mkRole` with `builtins.pathExists` for each optional UX Design chapter.
8. Append the UX Design chapter after the optional DDD chapter.
9. Keep every base role body unchanged.
10. Add `designer-expert` to `builtinRoles` only when UX Design is enabled.
11. Reuse `mkRole` so the designer expert keeps OpenCode subagent mode.
12. Add the designer expert task permission `deny` in
    `domain.agent.harness.opencode.settings.agent` only when UX Design is enabled.
13. Do not put task permission in `role.builder.<role>.harness.opencode`.
14. Preserve the current artifact-master permission and all current content-expert denials.
15. Read `domain.agent.harness.uses` and branch on the selected harnesses when `use` is `figma`.
16. Emit project-root `.mcp.json` with the Claude JSON `mcpServers` key.
17. Do not write Claude MCP configuration to `harness.claude.settings` or `.claude/settings.json`.
18. Write OpenCode `mcp` and Codex `mcp_servers` in their harness settings.
19. Use `lib.mkForce` at each nested cross-domain key and preserve unrelated harness settings.
20. Emit no MCP output when `use` is `unset` or UX Design is disabled.
21. Read the three chapters from `_assets/ux-design/agent/role/<role>/ROLE.md`.
22. Read the template from
    `_assets/ux-design/docs/wiki/documentation/artifact-driven/templates/change/design/README.md`.
23. Emit the Design template target as its own nested `files` key only when UX Design is enabled.
24. Keep the Design template source outside the always-copied documentation template source.
25. Do not change `AGENTS.md`, the artifact-driven README, or a mixture-of-experts page.
26. Keep the workflow at five phases.

## Check

1. Run `nix-instantiate --parse services/factory/composition/artifact-driven/default.nix`.
2. Inspect the diff and confirm that the existing agent block owns all UX Design domain output.
3. Confirm that each UX Design domain addition is in the existing agent composition block.
4. Confirm that the off branch adds no role, permission, chapter, template, or MCP output.
5. Confirm that Claude uses `.mcp.json` and does not use `.claude/settings.json` for MCP.
6. Confirm that OpenCode and Codex use their specified harness setting keys.
7. Confirm that the designer denial is in global OpenCode settings.
8. Confirm that `use` is the only design tool setting name.
9. Confirm that the template has its own nested `files` key.
10. Confirm that no always-copied asset changes.
11. Run the complete enabled and disabled checks in `task-ux-design-evals` after the authored files exist.
