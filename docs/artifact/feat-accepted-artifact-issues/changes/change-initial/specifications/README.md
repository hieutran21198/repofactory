# Specifications: Accepted artifact issues

## Solution

The factory generates a trusted GitHub Actions workflow for the selected project provider. The
workflow synchronizes each accepted feature artifact to one provider issue after a pull request
merges. It also supports a manual full scan. An optional webhook step sends one accepted change
summary to each selected Google Chat, Slack, and Telegram provider after synchronization succeeds.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-artifact-tree](spec-artifact-tree.md) | Define artifact identity, type, and parent rules. | req-artifact-hierarchy, req-portable-links |
| [spec-sync-workflow](spec-sync-workflow.md) | Define the merge and full-scan workflow. | req-accepted-only, req-portable-links |
| [spec-github-projects](spec-github-projects.md) | Map artifact issues to GitHub Issues and Projects. | req-artifact-hierarchy, req-configurable-status |
| [spec-trello](spec-trello.md) | Map artifact issues to Trello cards. | req-artifact-hierarchy, req-configurable-status |
| [spec-factory-options](spec-factory-options.md) | Define the public factory options and generated files. | req-configurable-status, req-accepted-only |

## Decisions

- [Create issues after acceptance](../decisions/adr-accepted-only.md)
- [Keep provider links out of artifacts](../decisions/adr-provider-links.md)
- [Use provider-native issue forms](../decisions/adr-provider-hierarchy.md)
- [Use a domain model for repository blueprints](../decisions/adr-blueprint-pattern.md)
- [Use repository-owned incoming webhook delivery](../../change-accepted-artifact-notifications/decisions/adr-incoming-webhook-delivery.md)
