# Specifications: Run all selected provider checks

**Change:** [Run all selected provider checks](../README.md)

## Solution

Isolate each provider execution from the other provider executions. Record a failed result for one
provider and continue with the next selected provider.

Retry GitHub Projects assertions for a short time after the workflow completes.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-provider-failure-isolation](spec-provider-failure-isolation.md) | Run all selected providers and collect their results. | req-artifact-hierarchy, req-configurable-status |
