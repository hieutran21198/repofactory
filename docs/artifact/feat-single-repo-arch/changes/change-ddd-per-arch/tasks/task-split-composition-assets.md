# task-split-composition-assets: Split the composition assets by architecture

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-guidance, req-single-context-rule, spec-composition-arch-trees

## Goal

The composition keeps one asset tree for each architecture, with the guidance, the DDD role
chapters, and the phase-mapping page of that architecture.

## Steps

1. Move `_assets/AGENTS.md` and `_assets/docs/wiki/README.md` to `_assets/multiple/`.
2. Move `_assets/ddd/AGENTS.md`, `_assets/ddd/docs/wiki/README.md`,
   `_assets/ddd/docs/wiki/design/ddd/artifact-driven.md`, and `_assets/ddd/agent/` to
   `_assets/multiple/ddd/`. Restore the wording that names `services/` only.
3. Copy the phase-mapping page and the role chapters to `_assets/single/ddd/`. Write the wording
   that names `src/` only, in the places that `spec-composition-arch-trees` gives.
4. Keep `_assets/docs/README.md`, `_assets/ddd/docs/README.md`, and `_assets/agent/` in place.
5. In `default.nix`, change the chapter path of `mkRole`, change the sources of the two
   architecture blocks, add the phase-mapping page to each block with `lib.optionalAttrs ddd`,
   and remove the block that emitted the page for every architecture. Do not touch the other
   blocks.
6. Check the Nix syntax with `nix-instantiate --parse`.

## Check

The module parses. `grep -rn 'src/' _assets/multiple` and `grep -rn 'services/' _assets/single`
return nothing.
