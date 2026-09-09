# Specifications: Trello Free workspaces

**Change:** [Support Trello Free workspaces](../README.md)

## Solution

Use each Trello card description as the canonical metadata store. Keep the configured Trello lists
as the status model. Keep the `Children` checklist as the hierarchy model.

Update the live Trello check to create and inspect only features that Trello Free supplies.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-trello-free](spec-trello-free.md) | Synchronize and check Trello cards without Custom Fields. | req-support-trello-free |
