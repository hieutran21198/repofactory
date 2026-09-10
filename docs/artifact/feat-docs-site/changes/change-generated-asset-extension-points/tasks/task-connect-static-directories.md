# task-connect-static-directories: Connect static directories and document the workflow

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-docs-site-files, spec-docusaurus-config, spec-docs-site-workflow
**Context:** context-factory

## Goal

Pass configured static directories to Docusaurus and document the generated-asset workflow.

## Steps

1. Add `staticDirectories` to the Nix-generated `site.json` value.
2. Read `site.staticDirectories` in the factory-owned Docusaurus configuration.
3. Add an option reference to the docs-site guide.
4. Add a LaTeX example that builds, copies, publishes, and checks one PDF.
5. State the path and working-directory rules in the guide.
6. State that a project does not need `docusaurus.config.local.js`.
7. Refresh the factory-owned files of this repository.
8. Review the changed prose with the ASD-STE-100 checklist.

## Check

Build the self-hosted documentation site. Confirm that its default static directory list is empty
and that the guide contains the complete example.
