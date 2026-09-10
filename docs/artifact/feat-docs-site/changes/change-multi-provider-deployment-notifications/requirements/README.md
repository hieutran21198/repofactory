# Requirements: Multiple deployment notification providers

## Business need

A repository maintainer needs to send a deployment notification to all required team destinations.

## Scope

- In scope: Google Chat, Slack, and Telegram deployment notifications.
- In scope: Independent delivery attempts for all selected providers.
- Out of scope: More than one destination for the same provider.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-multiple-deployment-providers](req-multiple-deployment-providers.md) | Send a deployment notification to all selected providers. | Must |

## Acceptance

A successful deployment sends the deployment message to each selected provider.
