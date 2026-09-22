# task-harness-ux-design-signal: Add the internal harness signal

**Plan:** [Implementation plan](README.md)
**Covers:** req-enable-flag, req-design-tool, spec-ux-design-option, spec-harness-mcp
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This task adds the shared input for later tasks in the same context and aggregate.

## Goal

Declare one internal Boolean signal that lets each harness receive the UX Design activation value.

## Files

- `services/factory/domain/agent/harness/default.nix`

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. Declare `${namespace}.domain.agent.harness.ux-design.enable` with `_utils.mkBoolOpt`.
2. Set `internal = true` on the option.
3. Set the default to `false`.
4. Keep the existing `domain.agent.harness.uses` option unchanged.
5. Do not add a `config` value to the module.
6. Do not add a `files` value to the module.
7. Do not add a harness-specific MCP value.
8. Keep the signal independent from the composition namespace.

## Check

1. Run `nix-instantiate --parse services/factory/domain/agent/harness/default.nix`.
2. Import the module with the option utility used by the local evaluations.
3. Assert that the option has `default = false` and `internal = true`.
4. Assert that the imported module has no `config` attribute.
5. Run the real module-system checks in `task-verify-harness-mcp`.
