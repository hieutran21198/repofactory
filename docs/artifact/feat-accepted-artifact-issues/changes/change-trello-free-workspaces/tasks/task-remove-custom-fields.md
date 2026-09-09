# task-remove-custom-fields: Remove the Custom Fields dependency

**Plan:** [Implementation plan](README.md)
**Covers:** req-support-trello-free, spec-trello-free
**Context:** context-factory

## Goal

Make description metadata the only metadata that the Trello adapter manages.

## Steps

1. Remove Custom Fields API calls from Trello preflight and upsert.
2. Scope card marker lookup to the configured repository.
3. Add adapter tests for API requests, metadata, identity, status, and rename behavior.
4. Update the generated Trello setup instructions.
5. Update the master feature artifacts to show the current contract.

## Check

Run the synchronizer unit suite and the artifact-driven composition module evaluation.
