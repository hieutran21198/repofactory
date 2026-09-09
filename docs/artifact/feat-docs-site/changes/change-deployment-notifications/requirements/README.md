# Requirements: Documentation site deployment notifications

**Change:** [Send documentation site deployment notifications](../README.md)

## Business need

A repository maintainer needs a team notification after the documentation site deploys.

## Scope

- In scope: Send one message after a successful documentation site deployment.
- In scope: Send the message to one Google Chat space or one Slack channel.
- In scope: Send messages for default-branch pushes and manual workflow runs.
- In scope: Report a notification failure after retry attempts.
- Out of scope: Send a message after a failed build or deployment.
- Out of scope: Enable a notification destination for a generated repository.
- Out of scope: Change the accepted artifact notification.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, GitHub Actions | Documentation site deployed, deployment notification sent |

## Requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-deployment-notification](req-deployment-notification.md) | Notify a team after the documentation site deploys. | Must |
