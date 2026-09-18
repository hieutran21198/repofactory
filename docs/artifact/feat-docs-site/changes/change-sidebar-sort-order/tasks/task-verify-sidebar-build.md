# task-verify-sidebar-build: Verify the sidebar with a Docusaurus build

**Plan:** [Implementation plan](README.md)
**Covers:** req-sidebar-sort-order, req-sidebar-feature-order-option, spec-docusaurus-config, spec-docs-site-files
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-check-feature-order-evaluation
**can-parallel:** no
**Parallel reason:** This final task executes the consumer after all source changes and Nix checks pass.

## Goal

Execute the comparator and verify its observable sidebar order with Docusaurus builds.

## Files

- `apps/documentation/site.json`, rendered data
- `apps/documentation/docusaurus.config.js`, regenerated factory copy
- `apps/documentation/build/<route>/index.html`, temporary build output

## Steps

1. Enter the project shell to render the docs-site files from the tracked configuration.
2. Confirm that `site.json.featureOrder` equals the approved ten-folder list.
3. Confirm that the rendered Docusaurus configuration comes from the generic factory asset.
4. Keep the regenerated configuration as an intended phase 4 commit file. Do not hand-edit it.
5. Install the pinned documentation dependencies.
6. Run a Docusaurus build with the approved full feature list.
7. Read each applicable `apps/documentation/build/<route>/index.html` file.
8. Extract the element whose class includes `theme-doc-sidebar-menu`.
9. Compare the ordered sidebar anchor text and targets in the extracted menu.
10. Confirm that direct index documents come first at their sibling level.
11. Confirm the phase order `requirements`, `specifications`, `decisions`, `tasks`.
12. Confirm descending semantic-version order and `change-initial` first.
13. Confirm the approved ten-folder feature order.
14. Temporarily add one sidebar fixture folder under `docs/`.
15. Give its sibling pages distinct source names and case-differing display labels.
16. Add sibling pages with non-BMP display labels and distinct source names.
17. Build and verify the case-insensitive fallback and deterministic code-point tie-breaks.
18. Temporarily replace the tracked `devenv.nix` list with a partial feature list.
19. Enter the shell, build, and confirm that listed folders precede sorted unlisted folders.
20. Temporarily replace the tracked list with an empty list.
21. Enter the shell, build, and confirm alphabetical feature order.
22. Remove `featureOrder` from the rendered `site.json` after the empty-list shell entry.
23. Without another shell entry, run the build directly and confirm the same alphabetical order.
24. Restore the approved root list and enter the shell again.
25. Confirm that final `devenv.nix` and `site.json` contain the approved full list.
26. Confirm that the regenerated Docusaurus copy matches the generic asset.
27. Confirm that the guide bytes and all copy modes are unchanged.
28. Remove the temporary fixture and all build output.
29. Confirm that the final working tree contains only intended phase 4 files.

## Check

Run the build for each required feature-order case:

```sh
cd apps/documentation && nix shell nixpkgs#nodejs_22 -c sh -c 'npm ci && npm run build'
```

Each build must exit with status zero. The extracted `theme-doc-sidebar-menu` content must meet the
applicable order rules. After the final render, `site.json.featureOrder` must contain the approved
full list.

Run `git diff --check`. Then run `git status --short`. Neither command can report a temporary
verification value, fixture, or build output. The status must include the intended regenerated
`apps/documentation/site.json` and `apps/documentation/docusaurus.config.js` files.
