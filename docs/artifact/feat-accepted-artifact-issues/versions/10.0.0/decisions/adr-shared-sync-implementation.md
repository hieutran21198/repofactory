# adr-shared-sync-implementation: Reuse one synchronizer across both CI systems

**Relates to:** spec-azure-pipelines-sync
**Context:** context-factory

## Context

The Azure pipeline must give the same result as the GitHub Actions workflow.
The synchronizer, the configuration schema, and the notifier already exist for
GitHub Actions. The change must not alter GitHub Actions behavior.

## Options

1. Reuse one synchronizer across both CI systems. Pro: One code path gives one
   result for both systems. Con: The pipeline file must map CI variables to
   the shared script inputs.
2. Write one synchronizer for each CI system. Pro: Each script uses native CI
   variables directly. Con: Two code paths can drift and give different
   results.

## Decision

Reuse one synchronizer across both CI systems. The Azure pipeline calls the
same `sync.py`, `notify.py`, and `config.json` as GitHub Actions. Only the
pipeline file and the variable mapping are new.

## Consequences

One adapter change fixes both CI systems. The Azure pipeline file must keep
the variable mapping aligned with the shared script inputs.
