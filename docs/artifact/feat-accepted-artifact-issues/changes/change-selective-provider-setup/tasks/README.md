# Implementation plan: Selective provider setup

**Change:** [Select a provider during setup](../README.md)

## Order

| Order | Task | Depends on |
| --- | --- | --- |
| 1 | [Add selective setup](task-add-selective-setup.md) | - |

## Completion

- The setup command accepts the provider selector.
- GitHub Projects setup does not need Trello credentials.
- Setup keeps the state of providers that it does not select.
- The unit checks pass.
