# Requirements: Accepted artifact issues

**Change:** [change-azure-pipelines-folder](../../../changes/change-azure-pipelines-folder/README.md)

## Business need

Repository maintainers use Azure DevOps setups that require a different
pipeline folder. These maintainers need a factory domain option that changes
the Azure Pipelines folder. When the maintainer leaves the option unset, the
factory must keep the default folder `azure-pipelines`. When the maintainer
sets a custom folder, the factory must emit the project-issues pipeline
`accepted-artifact-issues.yml` in that folder. Existing repositories must not
change unless the maintainer sets the option.

## Scope

- In scope: A factory domain option that changes the Azure Pipelines folder.
- In scope: The project-issues pipeline path follows the selected folder.
- In scope: The default folder stays `azure-pipelines` when the option is unset.
- In scope: The factory rejects an empty or invalid folder value.
- Out of scope: Change the docs-site pipeline path (a follow-up change covers it).
- Out of scope: Change GitHub Actions behavior.
- Out of scope: Add a new CI provider.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, Azure Pipelines | Azure Pipelines folder selected, artifact accepted on Azure Pipelines, artifact synchronized on Azure Pipelines, acceptance notified on Azure Pipelines |

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
| [req-azure-pipelines-folder](req-azure-pipelines-folder.md) | The factory must emit the project-issues pipeline in the selected Azure Pipelines folder. | Must |

## Acceptance

A repository that leaves the folder option unset keeps the project-issues
pipeline at `azure-pipelines/accepted-artifact-issues.yml`. A repository that
sets a custom folder emits the project-issues pipeline in that folder with the
same content. An empty or invalid folder value stops generation with a clear
error. GitHub Actions results do not change.
