# task-update-eval-checks: Update the module evaluation checks

**Plan:** [Implementation plan](README.md)
**Covers:** spec-ddd-arch-trees, spec-composition-arch-trees

## Goal

The checks of the DDD module and the composition assert the contracts of the two specifications.

## Steps

1. In `services/factory/domain/design/ddd/tests/eval.nix`, stub `lib.mkMerge` as a merge of the
   blocks. Evaluate `ddd` with `multiple`, `single`, and `unset`, and `unset` with `multiple`.
   Assert the targets, the copy modes, the source trees, and the source paths of
   `spec-ddd-arch-trees`.
2. In `services/factory/composition/artifact-driven/tests/eval.nix`, add `optionalAttrs` to the
   stub. Evaluate `multiple` and `single` with `ddd` and `unset`, and `unset` with `ddd`. Assert
   the guidance sources, the role instructions, and the phase-mapping page of
   `spec-composition-arch-trees`.
3. Run the four checks with `nix-instantiate --eval --strict`: the DDD module, the composition,
   the single module, and the multiple module.

## Check

Each check returns its result attribute set without an assertion error.
