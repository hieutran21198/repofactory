# task-add-ddd-seeds: Add the DDD file declarations and the seeds

**Plan:** [Implementation plan](README.md)
**Covers:** req-domain-model-artifacts, spec-ddd-files

## Goal

The DDD module emits the design guide, the templates, and the seeds of `docs/domain/`.

## Steps

1. Write the seeds `README.md`, `context-map.md`, and `glossary.md` in
   `services/factory/domain/design/ddd/_assets/docs/domain/`.
2. Add the five file declarations of `spec-ddd-files` to the DDD module with their copy modes.
3. Check the Nix syntax.

## Check

Evaluate the module with `design.use` set to `ddd`. The `files` attribute has the five targets
with the copy modes of `spec-ddd-files`, and each source path exists.
