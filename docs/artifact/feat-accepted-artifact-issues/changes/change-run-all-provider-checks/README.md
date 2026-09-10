# Change: Run all selected provider checks

**Feature:** [Accepted artifact issues](../../README.md)
**From:** 3.0.0
**To:** 3.1.0
**Type:** Specifications

## Reason

The end-to-end command stops after the first provider failure. Thus, the default command can omit
the Trello check when the GitHub Projects check fails.

GitHub Projects can also return old field values for a short time after a workflow completes.

## Effect

The command attempts every selected provider and reports all provider failures. The GitHub
Projects inspector retries assertions while provider data becomes consistent.

## Artifacts

- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
