# task-check-feature-order-evaluation: Check the feature-order interface and data

**Plan:** [Implementation plan](README.md)
**Covers:** req-sidebar-feature-order-option, spec-docusaurus-config, spec-docs-site-options, spec-docs-site-files
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-implement-sidebar-comparator
**can-parallel:** no
**Parallel reason:** This task checks both prior source tasks in the same component and aggregate.

## Goal

Check the Nix option, assertions, JSON data, file rules, and required generic-asset text.

## Files

- `services/factory/composition/artifact-driven/docs-site/tests/eval.nix`

## Steps

1. Add a `featureOrder` input with an empty-list default to the `moduleFor` test fixture.
2. Set `sidebar.feature-order = featureOrder` in each applicable fixture module.
3. Check that the option uses `listOf str` and defaults to an empty list.
4. Add a selected feature-order fixture and keep its list order.
5. Add fixtures for an empty string and a duplicate string.
6. Check the non-empty and case-sensitive uniqueness assertion messages.
7. Assert the declared `listOf str` test shape. Do not add a wrong-type fixture to this harness.
8. Do not claim that this direct-import harness executes module-system type rejection.
9. Add `featureOrder = []` to `siteJsonRoundTrip`.
10. Add `featureOrder = []` to `extensionSiteJsonRoundTrip`.
11. Check that a selected list occurs unchanged in parsed `site.json`.
12. Keep the cross-target `site.json` equality checks for all publication targets.
13. Compare parsed JSON values. Do not require a JSON object key order.
14. Escape or bracket each JavaScript regex metacharacter in asset-text patterns.
15. Match `site[.]featureOrder [?][?] [[]]` and stable text for the changed comparator surface.
16. Do not claim that text matching executes a helper or the JavaScript comparator.
17. Keep all copy-mode assertions unchanged.
18. Keep the guide text and guide-byte assertions unchanged.
19. Do not encode the illustrative specification example as option defaults.
20. Keep all existing docs-site checks.
21. Keep the separate composition evaluation unchanged as a regression guard.

## Check

Run these commands separately:

1. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
2. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`

Each command must exit with status zero. Each new Boolean assertion must be true. The docs-site
evaluation covers the new option, assertions, JSON values, file rules, and asset text. It checks
the declared string-list shape but does not execute module-system wrong-type rejection.

The second command is a regression guard. It does not provide feature-order coverage because it
does not import the docs-site module.
