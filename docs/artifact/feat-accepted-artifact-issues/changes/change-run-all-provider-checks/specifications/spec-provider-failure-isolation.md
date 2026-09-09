# spec-provider-failure-isolation: Isolate provider check failures

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Command contract

The default `test` command selects GitHub Projects and Trello. The command attempts both providers,
even when one provider fails.

The result report contains one entry for each selected provider. A failed entry contains the
provider name and its error. The command returns a nonzero exit status if one or more providers
fail.

## Assertion contract

The GitHub Projects inspector retries a failed item assertion for a limited time. This retry lets
the Project API apply status field updates after the workflow completes.

The inspector reports the last assertion error when the retry limit expires.

## Errors

- Keep the data from a failed provider for inspection.
- Continue with the next selected provider after a provider error.
- Report all provider errors after the last provider check.
