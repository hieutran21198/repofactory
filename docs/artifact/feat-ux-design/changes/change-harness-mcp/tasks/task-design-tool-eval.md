# task-design-tool-eval: Add the design-tool local evaluation

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-design-tool
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-codex-harness-mcp
**can-parallel:** no
**Parallel reason:** This task follows the harness tasks and changes the same context and aggregate.

## Goal

Make a local evaluation prove that the design-tool module owns only the passive `use` selection.

## Files

- `services/factory/domain/design-tool/tests/eval.nix`

The check reads `libs/nix/options/default.nix`. It does not change that component.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Import the design-tool module as `designToolModule` for the structure checks.
2. Inspect `designToolModule.options.factory.domain.design-tool`.
3. Assert that the design-tool domain declares only `use`.
4. Assert that `designToolModule` has no `config` attribute.
5. Check that the `use` default is `unset`.
6. Use the real option builders from `libs/nix/options/default.nix`.
7. Evaluate the option with the real `lib.evalModules` function.
8. Check the accepted values `unset` and `figma`.
9. Give the real module system an unsupported value.
10. Assert that the unsupported value fails option evaluation.
11. Keep each positive result as a Boolean assertion.

## Check

1. Run `nix-instantiate --eval --strict services/factory/domain/design-tool/tests/eval.nix`.
2. Confirm that all Boolean assertions pass.
3. Confirm that the negative fixture uses the real option builder and module system.
4. Confirm that the negative fixture rejects an unsupported value.
5. Confirm that the structure check uses the specified options path.
