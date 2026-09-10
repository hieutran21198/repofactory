# task-add-eval-checks: Add the module evaluation checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-layout, req-single-guidance, spec-single-seed, spec-single-composition

## Goal

Two evaluation checks assert the contracts of the single repository module and the composition.

## Steps

1. Add `services/factory/domain/repo-arch/single/tests/eval.nix` in the style of the DDD check.
   Assert the eight targets, the `seed` copy mode, and the source paths for `single`. Assert
   no `files` for `unset`. Assert that `multiple` emits no `src/README.md` and no
   `tests/README.md`.
2. Extend `services/factory/composition/artifact-driven/tests/eval.nix`. Give the architecture
   to the module evaluation. Assert the single-repository sources for `ddd` and for `unset`.
   Assert that the `single` block emits no file for `multiple`, and that the `multiple` block
   emits no file for `single`.
3. Run the four checks with `nix-instantiate --eval --strict`: the single module, the multiple
   module, the DDD module, and the composition.

## Check

Each check returns its result attribute set without an assertion error.
