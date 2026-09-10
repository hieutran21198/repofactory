# task-add-eval-checks: Add the module evaluation checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-option, req-role-ddd-extension, spec-ddd-files, spec-role-extension, spec-composition-guidance

## Goal

Two evaluation checks assert the contracts of the DDD module and the composition.

## Steps

1. Add `services/factory/domain/design/ddd/tests/eval.nix` in the style of the repo-arch check.
   Assert the five targets, their copy modes, and their source paths for `ddd`. Assert no
   `files` for `unset`.
2. Add `services/factory/composition/artifact-driven/tests/eval.nix`. Assert the role
   instructions, the guidance sources, and the phase-mapping page for `ddd` and for `unset`.
3. Run both checks with `nix-instantiate --eval --strict`.

## Check

Both checks return their result attribute set without an assertion error.
