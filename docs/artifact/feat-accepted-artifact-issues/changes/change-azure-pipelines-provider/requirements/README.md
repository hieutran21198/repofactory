# Requirements: Accepted artifact issues

**Change:** [change-azure-pipelines-provider](../../../changes/change-azure-pipelines-provider/README.md)

## Business need

Repository teams use Azure Pipelines for continuous integration. These teams need the same
accepted-artifact issue behavior that GitHub Actions provides today. After an artifact pull
request merges, the factory must make and update project issues. The issues must show the same
hierarchy, type labels, and first statuses. The factory must support the same provider setup,
Trello workspaces, and notifications. GitHub Actions behavior must not change.

## Scope

- In scope: Synchronize accepted artifacts on Azure Pipelines.
- In scope: Show the artifact hierarchy, type labels, and first status on Azure Pipelines.
- In scope: Support selective provider setup on Azure Pipelines.
- In scope: Support Trello Free workspaces on Azure Pipelines.
- In scope: Support split Trello planning and implementation boards on Azure Pipelines.
- In scope: Resolve a Trello board reference to its board ID on Azure Pipelines.
- In scope: Send notifications to each selected Google Chat, Slack, and Telegram provider on Azure Pipelines.
- Out of scope: Change GitHub Actions behavior.
- Out of scope: Add a new project provider.
- Out of scope: Add a new notification provider.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, Azure Pipelines | Artifact accepted on Azure Pipelines, artifact synchronized on Azure Pipelines, acceptance notified on Azure Pipelines |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-accepted-only](req-accepted-only.md) | Synchronize only accepted artifacts. | Must |
| [req-artifact-hierarchy](req-artifact-hierarchy.md) | Reproduce the artifact hierarchy in the selected provider. | Must |
| [req-portable-links](req-portable-links.md) | Keep issue links out of artifact content. | Must |
| [req-configurable-status](req-configurable-status.md) | Configure the first status for each artifact type. | Must |
| [req-select-provider](req-select-provider.md) | The setup command must accept a provider selection. | Must |
| [req-support-trello-free](req-support-trello-free.md) | Trello synchronization must not require Custom Fields. | Must |
| [req-artifact-type-labels](req-artifact-type-labels.md) | Project items must show their artifact type with a label. | Must |
| [req-split-trello-boards](req-split-trello-boards.md) | Trello synchronization must support separate planning and implementation boards. | Must |
| [req-accepted-artifact-notification](req-accepted-artifact-notification.md) | Notify a team after accepted artifact synchronization. | Must |
| [req-multiple-accepted-artifact-providers](req-multiple-accepted-artifact-providers.md) | Send an accepted-artifact notification to all selected providers. | Must |
| [req-resolve-trello-board-id](req-resolve-trello-board-id.md) | The adapter must use the resolved board ID for managed label creation. | Must |
| [req-azure-pipelines-sync](req-azure-pipelines-sync.md) | Synchronize accepted artifacts on Azure Pipelines with the same result. | Must |

## Acceptance

A merged artifact pull request on Azure Pipelines makes one issue for each artifact file. Each
issue shows its hierarchy, its artifact type label, and its first status. A rejected pull request
makes no issue. Repeated runs make no duplicate issues. Trello synchronization works on a Free
workspace, on one board or on two boards, with the resolved board ID. Each selected provider
receives one notification. GitHub Actions results do not change.
