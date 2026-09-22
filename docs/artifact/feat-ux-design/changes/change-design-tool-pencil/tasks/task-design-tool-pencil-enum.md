# task-design-tool-pencil-enum: Add the `pencil` design-tool value

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool, spec-pencil-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This task supplies the shared `pencil` value for the later adapter tasks in the same context and aggregate.

## Goal

Add `pencil` to the passive design-tool selection and prove the three-value contract with the
module-local evaluation.

## Scope

- `services/factory/domain/design-tool/default.nix`
- `services/factory/domain/design-tool/tests/eval.nix`

This task changes no other file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Add `"pencil"` to the `values` list of `${namespace}.domain.design-tool.use`.
2. Keep `default = "unset"`.
3. Keep the option at the `domain.design-tool.use` path. Keep it separate from `domain.design.use`.
4. Keep the module free of a `config` value. A module without `config` emits no file and no MCP
   setting.
5. In `services/factory/domain/design-tool/tests/eval.nix`, expect the values
   `["unset" "figma" "pencil"]`.
6. Add a positive evaluation of `pencil` with the real option builders.
7. Keep the positive evaluations of `unset` and `figma`.
8. Keep the default assertion `unset`.
9. Keep the assertion that the domain declares only `use`.
10. Keep the assertion that the imported module has no `config` attribute.
11. Keep the negative evaluation with an unsupported value.
12. Keep each result as a Boolean assertion.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/design-tool/tests/eval.nix`.
2. Confirm that all Boolean assertions pass.
3. Confirm that the permitted values are `unset`, `figma`, and `pencil`.
4. Confirm that the default is `unset`.
5. Confirm that the module emits no file and no MCP setting.
6. Confirm that the unsupported value fails option evaluation.

## Definition of done

- The `use` option accepts `unset`, `figma`, and `pencil`.
- The default is `unset`.
- The module declares only `use` and has no `config` value.
- The module-local evaluation passes.
