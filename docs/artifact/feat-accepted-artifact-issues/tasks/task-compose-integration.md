# task-compose-integration: Compose the generated integration

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-configurable-status, spec-factory-options, spec-sync-workflow
**Context:** context-factory

## Goal

Generate the selected workflow, synchronizer, configuration, and setup guide.

## Steps

1. Add explicit activation and artifact status policy to the artifact-driven composition.
2. Add provider-specific workflow text to the artifact-driven composition.
3. Add the synchronizer and configuration files.
4. Add the setup guide.
5. Stop evaluation for an incomplete enabled composition.

## Check

Evaluate the composition matrix and compare all generated file sources and content.
