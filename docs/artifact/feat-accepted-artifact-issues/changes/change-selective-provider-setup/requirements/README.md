# Requirements: Selective provider setup

**Change:** [Select a provider during setup](../README.md)

## Business need

A repository maintainer needs to set up one live-provider check without credentials for the other
provider.

## Scope

- In scope: Select GitHub Projects, Trello, or both providers during setup.
- Out of scope: Change the resources or credentials that each provider needs.

## Requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-select-provider](req-select-provider.md) | The setup command must accept a provider selection. | Must |

