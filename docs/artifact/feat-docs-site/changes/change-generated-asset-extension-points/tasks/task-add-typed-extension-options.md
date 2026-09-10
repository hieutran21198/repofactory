# task-add-typed-extension-options: Add typed extension options

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-docs-site-options, spec-docs-site-workflow
**Context:** context-factory

## Goal

Add the typed static directory, watch path, and workflow step options to the docs-site module.

## Steps

1. Declare the workflow step submodule with the six specified fields.
2. Declare the five list options with empty-list defaults.
3. Add assertions for empty paths and invalid step relations.
4. Add YAML helpers that safely render paths, maps, and typed steps.
5. Insert the watch paths and step lists at the specified workflow points.
6. Keep the default workflow text unchanged.
7. Format the changed Nix file.

## Check

Evaluate the module with empty and extended configurations. Compare the default workflow with the
current workflow. Check that invalid step relations produce false assertions.
