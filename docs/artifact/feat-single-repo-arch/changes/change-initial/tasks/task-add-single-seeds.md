# task-add-single-seeds: Add the single repository seeds

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-layout, spec-single-seed, spec-single-page

## Goal

The single repository module seeds the root layout of the architecture.

## Steps

1. Rewrite `services/factory/domain/repo-arch/single/default.nix` in the shape of the multiple
   repositories module. Remove the unused bindings.
2. Add the file map of `spec-single-seed`. Each target uses the `seed` copy mode.
3. Write the directory seeds of `spec-single-page` in `single/_assets/`: `README.md`,
   `AGENTS.md`, `docs/README.md`, `docs/wiki/README.md`, `src/README.md`, `tests/README.md`,
   and `deployment/README.md`.
4. Check the Nix syntax with `nix-instantiate --parse`.

## Check

The module parses. Each source path in the file map exists.
