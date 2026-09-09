# Requirements: Accepted artifact notifications

**Change:** [Send accepted artifact notifications](../README.md)

## Business need

A repository maintainer needs a team notification when a pull request changes accepted artifacts.

## Scope

- In scope: Send one summary after successful artifact synchronization.
- In scope: Send the summary to one Google Chat space or one Slack channel.
- In scope: Report added, updated, renamed, and withdrawn artifacts.
- Out of scope: Send documentation site deployment notifications.
- Out of scope: Send notifications for manual scans or pull requests without artifact changes.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, GitHub Actions | Accepted artifacts synchronized, acceptance notification sent |

## Requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-accepted-artifact-notification](req-accepted-artifact-notification.md) | Notify a team after accepted artifact synchronization. | Must |
