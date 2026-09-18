# task-add-feature-order-data-path: Add the feature-order data path

**Plan:** [Implementation plan](README.md)
**Covers:** req-sidebar-feature-order-option, spec-docs-site-options, spec-docs-site-files
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** This upstream task changes the shared composition before its consumer and checks.

## Goal

Carry one validated feature-folder order from a tracked Nix option to `site.json.featureOrder`.

## Files

- `services/factory/composition/artifact-driven/docs-site/default.nix`
- `devenv.nix`, with an owner selected by the artifact master
- `apps/documentation/site.json`, rendered and committed from the tracked root option

## Steps

1. Declare `sidebar.feature-order` with `_utils.mkListOpt`.
2. Set `ofType = lib.types.str` and `default = []`.
3. Add an enabled assertion that rejects an empty string list element.
4. Add an enabled assertion that rejects a case-sensitive duplicate with `lib.unique`.
5. Name `sidebar.feature-order` and the failed rule in each assertion message.
6. Write `docsSite.sidebar.feature-order` to `site.json` as `featureOrder`.
7. Keep every list value and its position without normalization.
8. Have the artifact-master-selected owner set the approved ten-folder list in the tracked root
   `devenv.nix` module.
9. Keep `devenv.local.nix` unchanged.
10. Render this repository's `site.json` from the tracked option. Do not hand-edit the JSON.
11. Keep the rendered `site.json` as an intended phase 4 commit file.
12. Add no file and change no copy mode.
13. Keep the docs-site guide bytes unchanged.
14. Do not hand-edit `apps/documentation/docusaurus.config.js`.

## Check

This task has no independent runnable Nix check. Its new JSON field breaks the old exact
round-trip expectations until `task-check-feature-order-evaluation` updates them.

Inspect the source diff. Confirm the option shape, both assertions, the JSON field, and the root
option value. After the evaluation task passes, read the rendered `apps/documentation/site.json`.
Its `featureOrder` value must equal the approved ten-folder list in `devenv.nix`.
