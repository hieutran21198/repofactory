# Requirements: Accepted artifact issues

## Business need

Repository maintainers need a project view of accepted feature artifacts. The repository must
stay the source of truth, and a rejected proposal must not make project data. Teams that use
Trello need the same result on Trello Free workspaces, on one board or on separate planning and
implementation boards. Teams need a notification on their selected chat providers after each
accepted change.

## Scope

- In scope: Create and update project issues after an artifact pull request merges.
- In scope: Show the artifact hierarchy in GitHub Projects or Trello.
- In scope: Show the artifact type of each project item with a label.
- In scope: Let each artifact type select its first project status.
- In scope: Let the setup command select the providers to configure.
- In scope: Support Trello Free workspaces without Custom Fields.
- In scope: Route implementation plans and tasks to a separate Trello implementation board.
- In scope: Resolve a configured Trello board reference to its internal ID before label creation.
- In scope: Optionally notify one or more Google Chat, Slack, and Telegram providers after synchronization.
- Out of scope: Create project issues before a pull request merges.
- Out of scope: Put provider URLs in artifact files.
- Out of scope: Make or repair an external project board.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, GitHub Actions | Artifact accepted, artifact withdrawn, acceptance notified |

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

## Acceptance

A merged artifact pull request makes one issue for each artifact file, with a label that shows its
artifact type. A rejected pull request makes no issue. Repeated workflow runs make no duplicate
issues. Trello synchronization works on a Free workspace, on one board or on two boards, and
creates managed labels with the resolved board ID. An enabled acceptance notification summarizes
the synchronized changes of one merged pull request on each selected provider.
