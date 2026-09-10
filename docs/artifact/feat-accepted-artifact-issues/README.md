# Feature: Accepted artifact issues

**Current version:** 8.1.0

## Summary

This feature creates project issues for feature artifacts after their pull request merges. The
issues show the artifact hierarchy and link to the accepted repository content. An optional
Google Chat, Slack, or Telegram notifications summarize the accepted changes.

## Current artifacts

- [Requirements](versions/8.1.0/requirements/README.md)
- [Specifications](versions/8.1.0/specifications/README.md)
- [Decisions](versions/8.1.0/decisions/)

## Versions

| Version | Change | Type | Commits |
| --- | --- | --- | --- |
| 1.0.0 | [Initial](changes/change-initial/README.md) | Requirements | 6d1c7c5 |
| 1.1.0 | [Composition-owned artifact policy](changes/change-composition-owned-policy/README.md) | Specifications, Decisions | e78150a..ac13b00 |
| 1.2.0 | [Add live provider end-to-end checks](changes/change-live-provider-e2e/README.md) | Specifications, Decisions | 493e092..8cd183e |
| 1.3.0 | [Provider credential guide](changes/change-provider-credential-guide/README.md) | Specifications, Decisions | d4377d9..a0ab5d9 |
| 2.0.0 | [Select a provider during setup](changes/change-selective-provider-setup/README.md) | Requirements | cde3dba..8cd183e |
| 2.1.0 | [Permit pull request comments](changes/change-pull-request-comment-permission/README.md) | Specifications | b695e05..8cd183e |
| 3.0.0 | [Support Trello Free workspaces](changes/change-trello-free-workspaces/README.md) | Requirements | 12f9b8e..d9a2680 |
| 3.1.0 | [Run all selected provider checks](changes/change-run-all-provider-checks/README.md) | Specifications | abf1336..dbdc191 |
| 4.0.0 | [Show artifact types with labels](changes/change-artifact-type-labels/README.md) | Requirements | 65a2d15..944574a |
| 5.0.0 | [Split Trello planning and implementation boards](changes/change-split-trello-boards/README.md) | Requirements | 485d620..12ff8bb |
| 6.0.0 | [Send accepted artifact notifications](changes/change-accepted-artifact-notifications/README.md) | Requirements | 57488e4..1e79b13 |
| 7.0.0 | [Use multiple accepted-artifact notification providers](changes/change-multi-provider-accepted-artifact-notifications/README.md) | Requirements | 555ec58 |
| 8.0.0 | [Resolve Trello board IDs before label creation](changes/change-trello-board-id/README.md) | Requirements | 5b5d713..7236e9e |
| 8.1.0 | [Artifact versions](changes/change-artifact-versions/README.md) | Specifications | 9ccc3ff |

Versions 1.0.0 to 7.0.0 have no folder in `versions/`. They were folded into 8.0.0 when the
artifacts moved to the changes and versions layout. Versions 8.0.0 and 8.1.0 have a folder. Read
the change of each version for the artifacts of that step.

## Artifacts

- [Changes](changes/), one folder for each change. Read a change for the reason.
- [Versions](versions/), one folder for each version. Read the current version for the state.
