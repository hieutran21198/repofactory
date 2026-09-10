# Change: Add generated asset extension points

**Feature:** [Documentation site](../../README.md)
**From:** 3.0.0
**To:** 4.0.0
**Type:** Requirements

## Reason

A downstream repository can generate files that the documentation site must publish. Today, the
repository must replace the complete `docusaurus.config.js` or docs-site workflow to add these
files. This replacement removes the typed contract with the factory and can miss later factory
changes.

The docs-site composition must give downstream repositories typed options for static directories,
workflow watch paths, and build steps. The factory must continue to own the Docusaurus configuration
and the workflow.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
