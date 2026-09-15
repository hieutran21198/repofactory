# adr-shared-site-implementation: Reuse one site builder and one notifier across both CI systems

**Relates to:** spec-docs-site-azure-pipeline
**Context:** context-factory

## Context

The Azure pipeline must give the same result as the GitHub Actions workflow. The site project, the
Docusaurus configuration, the typed extension values, and the notifier already exist for GitHub
Actions. The change must not alter GitHub Actions behavior.

## Options

1. Reuse one site builder and one notifier across both CI systems. Pro: One code path gives one
   result for both systems. Con: The pipeline file must map CI variables to the shared notifier
   inputs.
2. Write one builder and one notifier for each CI system. Pro: Each script uses native CI
   variables directly. Con: Two code paths can drift and give different results.

## Decision

Reuse one site builder and one notifier across both CI systems. The Azure pipeline builds the same
`apps/documentation/` project and calls the same `.github/docs-site/notify.py` as GitHub Actions.
Only the pipeline file and the variable mapping are new.

## Consequences

One site or notifier change fixes both CI systems. The Azure pipeline file must keep the variable
mapping aligned with the shared notifier inputs.
