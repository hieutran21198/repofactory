# Requirements: Multiple accepted-artifact notification providers

## Business need

A repository maintainer needs to send an accepted-artifact notification to all required team destinations.

## Scope

- In scope: Google Chat, Slack, and Telegram accepted-artifact notifications.
- In scope: Independent delivery attempts for all selected providers.
- Out of scope: More than one destination for the same provider.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-multiple-accepted-artifact-providers](req-multiple-accepted-artifact-providers.md) | Send an accepted-artifact notification to all selected providers. | Must |

## Acceptance

A successful synchronization with artifact changes sends a summary to each selected provider.
