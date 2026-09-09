# task-isolate-provider-checks: Isolate provider checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, spec-provider-failure-isolation
**Context:** context-factory

## Goal

Run every selected provider and tolerate short GitHub Projects API delays.

## Steps

1. Catch errors for each provider execution.
2. Add each provider result to the report.
3. Report the collected errors after all provider executions.
4. Retry GitHub Projects item assertions for a limited time.
5. Use stable Trello short URLs for hierarchy links.
6. Add unit tests for provider failure isolation and assertion retries.
7. Update the end-to-end specification and instructions.

## Check

Run the local E2E unit suite. Run the default live `test` command with both providers.
