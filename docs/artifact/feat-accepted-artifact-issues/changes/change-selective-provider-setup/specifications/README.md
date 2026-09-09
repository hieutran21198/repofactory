# Specifications: Selective provider setup

**Change:** [Select a provider during setup](../README.md)

## Solution

The setup command uses the same provider selector as the test and cleanup commands. Setup checks
credentials and creates resources only for the selected providers.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-selective-setup](spec-selective-setup.md) | Define selective setup and partial state. | req-select-provider |

