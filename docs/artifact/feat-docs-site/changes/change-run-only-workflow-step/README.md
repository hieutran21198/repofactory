# Change: Fix run-only workflow steps

**Feature:** [Documentation site](../../README.md)
**From:** 4.0.0
**To:** 4.0.1
**Type:** Correction

## Reason

A workflow step with `run` and without `uses` matches the public contract. The Nix submodule keeps
an undefined `uses` option as an error value. The validator accesses that value and stops evaluation.

The implementation must represent optional string fields with a null default. It must render and
validate only fields that have a non-null value.

## Artifacts

- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
