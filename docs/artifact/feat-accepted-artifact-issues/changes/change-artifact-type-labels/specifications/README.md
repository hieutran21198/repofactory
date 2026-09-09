# Specifications: Artifact type labels

**Change:** [Show artifact types with labels](../README.md)

## Solution

Add the same managed label names to GitHub repository issues and Trello cards. Reserve the
`artifact:` prefix for labels that Repofactory manages.

Keep the artifact body or description as the canonical metadata store. Keep provider status and
hierarchy behavior unchanged.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-artifact-type-labels](spec-artifact-type-labels.md) | Manage artifact type labels in both providers. | req-artifact-type-labels |
