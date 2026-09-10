# task-add-design-domain: Add the design domain and its option

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-option, spec-design-option

## Goal

The factory has a `design` domain with the option `design.use` and an empty DDD module.

## Steps

1. Add `services/factory/domain/design/default.nix` with the option of `spec-design-option`.
2. Add `services/factory/domain/design/ddd/default.nix` with a `files` block guarded by
   `design.use == "ddd"`.
3. Check the Nix syntax.

## Check

Evaluate the module with `design.use` set to `ddd` and to `unset`. The evaluation succeeds. An
unknown value fails.
