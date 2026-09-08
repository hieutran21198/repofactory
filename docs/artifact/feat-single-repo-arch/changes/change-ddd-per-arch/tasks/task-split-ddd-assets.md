# task-split-ddd-assets: Split the DDD assets by architecture

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-context-rule, spec-ddd-arch-trees

## Goal

The DDD module keeps one asset tree for each architecture and emits the tree of the active
architecture only.

## Steps

1. Move the design guide and the templates to `_assets/multiple/docs/wiki/design/ddd/`. Restore
   the wording that names `services/` only.
2. Copy the tree to `_assets/single/docs/wiki/design/ddd/`. Write the wording that names `src/`
   only, in the places that `spec-ddd-arch-trees` gives.
3. Keep the `docs/domain/` seeds in `_assets/docs/domain/`.
4. Rewrite `default.nix` with one block for the seeds and one block for each architecture, in
   one `lib.mkMerge`.
5. Check the Nix syntax with `nix-instantiate --parse`.

## Check

The module parses. `grep -rn 'src/' _assets/multiple` and `grep -rn 'services/' _assets/single`
return nothing.
