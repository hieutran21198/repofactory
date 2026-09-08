# Specifications: Composition-owned artifact policy

## Solution

The artifact-driven project-issues composition owns its enable option and the first status of each
artifact type. The project-management domain selects one adapter. Each adapter keeps its own
target and credential settings. An enabled composition combines these settings and stops Nix
evaluation when its domain selections or selected adapter settings are not valid.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-composition-options](spec-composition-options.md) | Define ownership, activation, and validation of the project-issues composition. | req-configurable-status, req-accepted-only |

## Decisions

- [Keep lifecycle policy in the composition](../decisions/adr-composition-owned-policy.md)
