# Requirements: Accepted artifact issues

## Business need

Repository maintainers need a project view of accepted feature artifacts. The repository must
stay the source of truth, and a rejected proposal must not make project data.

## Scope

- In scope: Create and update project issues after an artifact pull request merges.
- In scope: Show the artifact hierarchy in GitHub Projects or Trello.
- In scope: Let each artifact type select its first project status.
- In scope: Optionally notify one or more Google Chat, Slack, and Telegram providers after synchronization.
- Out of scope: Create project issues before a pull request merges.
- Out of scope: Put provider URLs in artifact files.
- Out of scope: Make or repair an external project board.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, GitHub Actions | Artifact accepted, artifact withdrawn |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-accepted-only](req-accepted-only.md) | Synchronize only accepted artifacts. | Must |
| [req-artifact-hierarchy](req-artifact-hierarchy.md) | Reproduce the artifact hierarchy in the selected provider. | Must |
| [req-portable-links](req-portable-links.md) | Keep issue links out of artifact content. | Must |
| [req-configurable-status](req-configurable-status.md) | Configure the first status for each artifact type. | Must |

## Acceptance

A merged artifact pull request makes one issue for each artifact file. A rejected pull request
makes no issue. Repeated workflow runs make no duplicate issues. An enabled acceptance notification
summarizes synchronized changes from one merged pull request.
