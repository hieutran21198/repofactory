# Implementation plan: Run all selected provider checks

**Change:** [Run all selected provider checks](../README.md)

## Order

| Order | Task | Depends on |
| --- | --- | --- |
| 1 | [Isolate provider checks](task-isolate-provider-checks.md) | - |

## Completion

- A first-provider failure does not omit the second provider.
- The report contains each selected provider.
- GitHub Projects status assertions tolerate short API delays.
- The local E2E unit suite passes.
