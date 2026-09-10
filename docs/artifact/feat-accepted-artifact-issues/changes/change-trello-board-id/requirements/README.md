# Requirements: Resolve Trello board IDs

**Change:** [Resolve Trello board IDs before label creation](../README.md)

## Business need

A repository maintainer can configure Trello with a board short link. Artifact synchronization must
create missing managed labels with the board ID that Trello requires.

## Scope

- In scope: Resolve a configured Trello board reference before a managed label is created.
- Out of scope: Change the configured board reference format.

## Requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-resolve-trello-board-id](req-resolve-trello-board-id.md) | The adapter must use the resolved board ID for managed label creation. | Must |
