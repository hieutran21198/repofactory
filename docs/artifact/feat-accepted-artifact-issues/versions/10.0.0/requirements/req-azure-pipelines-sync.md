# req-azure-pipelines-sync: Synchronize accepted artifacts on Azure Pipelines

**Master:** [Requirements](README.md)
**Covers:** none (new requirement)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must synchronize accepted artifacts on Azure Pipelines with the same result as on
GitHub Actions.

## Acceptance criteria

- Given a merged artifact pull request on Azure Pipelines, when synchronization runs, then it makes and updates the same project issues as GitHub Actions.
- Given a merged artifact pull request on Azure Pipelines, when synchronization runs, then each issue shows the hierarchy, the type label, and the first status.
- Given an artifact pull request that closes without merge on Azure Pipelines, when synchronization runs, then it makes no project issue.
- Given a merged artifact pull request on Azure Pipelines, when synchronization runs two times, then it makes no duplicate issue.
- Given a Trello Free workspace on Azure Pipelines, when synchronization runs, then it makes issues without Custom Fields.
- Given split planning and implementation boards on Azure Pipelines, when synchronization runs, then it routes each plan and each task to the right board.
- Given a configured Trello board reference on Azure Pipelines, when synchronization runs, then it creates managed labels with the resolved board ID.
- Given selected Google Chat, Slack, and Telegram providers on Azure Pipelines, when synchronization succeeds, then each provider receives one summary.
- Given a repository that uses GitHub Actions, when synchronization runs, then the result does not change.

## Notes

The change is additive. The setup choice covers the CI provider. GitHub Actions keeps its result.
