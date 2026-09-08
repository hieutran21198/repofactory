# task-compose-integration: Compose the generated integration

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-configurable-status, spec-factory-options, spec-sync-workflow
**Context:** context-factory

## Goal

Generate the selected workflow, synchronizer, configuration, and setup guide.

## Steps

1. Add provider-specific workflow text to the artifact-driven composition.
2. Add the synchronizer and configuration files.
3. Add the setup guide.
4. Emit no files for an incomplete selector combination.

## Check

Evaluate the composition matrix and compare all generated file sources and content.
