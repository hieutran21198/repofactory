# task-design-tool-option: Add the design-tool option

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This task adds an upstream option in the only changed context and aggregate.

## Goal

Declare the optional design tool with one closed `use` setting and no generated output.

## Files

- `services/factory/domain/design-tool/default.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Add the auto-discovered `domain.design-tool` module.
2. Declare only `${namespace}.domain.design-tool.use`.
3. Use `_utils.mkEnumOpt` with `unset` and `figma`.
4. Set the default to `unset`.
5. Keep `domain.design-tool.use` separate from `domain.design.use`.
6. Add no config block, generated file, MCP setting, or composition rule.
7. Keep `use` as the only name for the design tool setting.

## Check

1. Run `nix-instantiate --parse services/factory/domain/design-tool/default.nix`.
2. Confirm that the module declares only `domain.design-tool.use`.
3. Confirm that the values are `unset` and `figma`.
4. Confirm that the default is `unset`.
5. Confirm that the module emits no file and writes no harness setting.
6. Run the final option assertions in `task-ux-design-evals`.
