# Specifications: Accepted artifact issues

**Change:** [change-azure-pipelines-provider](../../../changes/change-azure-pipelines-provider/README.md)

## Solution

The factory adds `azure-pipelines` to the CI provider option. The value
`github-actions` keeps its files, its workflow, and its result. The value
`azure-pipelines` emits one Azure pipeline. The Azure pipeline runs the same
synchronizer, the same configuration, and the same notifier as GitHub Actions.
The project-issues composition accepts either CI provider. Provider adapters,
target settings, and credential names stay the same across both CI systems.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-artifact-tree](spec-artifact-tree.md) | Define artifact identity, type, and parent rules. | req-artifact-hierarchy, req-portable-links |
| [spec-sync-workflow](spec-sync-workflow.md) | Define the merge and full-scan workflow. | req-accepted-only, req-portable-links |
| [spec-github-projects](spec-github-projects.md) | Map artifact issues to GitHub Issues and Projects. | req-artifact-hierarchy, req-configurable-status |
| [spec-trello](spec-trello.md) | Map artifact issues to Trello cards. | req-artifact-hierarchy, req-configurable-status, req-portable-links |
| [spec-factory-options](spec-factory-options.md) | Define the public factory options and generated files. | req-configurable-status, req-accepted-only |
| [spec-composition-options](spec-composition-options.md) | Define ownership, activation, and validation of the project-issues composition. Details the ownership contract of spec-factory-options. | req-configurable-status, req-accepted-only |
| [spec-live-provider-e2e](spec-live-provider-e2e.md) | Check the artifact life cycle with both live providers. | req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status |
| [spec-provider-credential-guide](spec-provider-credential-guide.md) | Generate credential procedures for both providers. | req-configurable-status |
| [spec-selective-setup](spec-selective-setup.md) | Define selective setup and partial state. | req-select-provider |
| [spec-comment-permission](spec-comment-permission.md) | Give the workflow access to write its managed comment. | req-portable-links |
| [spec-trello-free](spec-trello-free.md) | Synchronize and check Trello cards without Custom Fields. | req-support-trello-free |
| [spec-provider-failure-isolation](spec-provider-failure-isolation.md) | Run all selected providers and collect their results. | req-artifact-hierarchy, req-configurable-status |
| [spec-artifact-type-labels](spec-artifact-type-labels.md) | Manage artifact type labels in both providers. | req-artifact-type-labels |
| [spec-split-trello-boards](spec-split-trello-boards.md) | Route and migrate Trello cards across two boards. | req-split-trello-boards |
| [spec-accepted-artifact-notification](spec-accepted-artifact-notification.md) | Configure and deliver an acceptance summary. Superseded in part by spec-multiple-accepted-artifact-providers. | req-accepted-artifact-notification |
| [spec-multiple-accepted-artifact-providers](spec-multiple-accepted-artifact-providers.md) | Define provider configuration and delivery for all selected providers. | req-multiple-accepted-artifact-providers |
| [spec-resolve-trello-board-id](spec-resolve-trello-board-id.md) | Resolve a board reference before managed label creation. | req-resolve-trello-board-id |
| [spec-ci-cd-provider](spec-ci-cd-provider.md) | Define the CI provider option with Azure Pipelines. | req-azure-pipelines-sync |
| [spec-azure-pipelines-sync](spec-azure-pipelines-sync.md) | Define the Azure pipeline trigger, files, and result contract. | req-azure-pipelines-sync, req-accepted-only, req-artifact-hierarchy, req-configurable-status, req-artifact-type-labels, req-support-trello-free, req-split-trello-boards, req-resolve-trello-board-id, req-multiple-accepted-artifact-providers, req-accepted-artifact-notification, req-portable-links |

## Decisions

- [Reuse one synchronizer across both CI systems](../decisions/adr-shared-sync-implementation.md)
- [Map secret names one to one onto Azure secret variables](../decisions/adr-azure-secret-mapping.md)
