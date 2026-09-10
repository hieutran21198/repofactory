# Specifications: Accepted artifact issues

## Solution

The factory generates a trusted GitHub Actions workflow for the selected project providers. The
workflow synchronizes each accepted feature artifact to one provider issue after a pull request
merges. It also supports a manual full scan. Each artifact issue carries a managed type label. The
Trello adapter works without Custom Fields, routes plans and tasks to an optional implementation
board, and resolves each board reference to its internal ID before it creates a label. The
composition owns the lifecycle policy of the project issues. An optional webhook step sends one
accepted change summary to each selected Google Chat, Slack, and Telegram provider after
synchronization succeeds.

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

## Decisions

- [Create issues after acceptance](../decisions/adr-accepted-only.md)
- [Keep provider links out of artifacts](../decisions/adr-provider-links.md)
- [Use provider-native issue forms](../decisions/adr-provider-hierarchy.md)
- [Use a domain model for repository blueprints](../decisions/adr-blueprint-pattern.md)
- [Keep lifecycle policy in the composition](../decisions/adr-composition-owned-policy.md)
- [Keep persistent provider sandboxes](../decisions/adr-persistent-sandboxes.md)
- [Generate one provider credential guide](../decisions/adr-generated-credential-guide.md)
- [Use repository-owned incoming webhook delivery](../decisions/adr-incoming-webhook-delivery.md)
