# task-compose-single-guidance: Compose the single repository guidance

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-guidance, spec-single-composition

## Goal

The artifact-driven composition emits the single-repository guidance variants when
`repo-arch.use` is `single`.

## Steps

1. Replace the placeholder block for `repo-arch.use == "single"` in
   `services/factory/composition/artifact-driven/default.nix` with the block of
   `spec-single-composition`.
2. Write the four assets in `_assets/single/` and `_assets/single/ddd/`. Start from the
   `multiple` variants. Change the architecture link and the component sentences.
3. Change the read list of `_assets/agent/role/solution-expert/ROLE.md` to name the page in
   `docs/wiki/repo-arch/` without the architecture name.
4. Do not move the assets of the `multiple` architecture.

## Check

The module parses. Each selected source exists. The `multiple` variants are unchanged.
