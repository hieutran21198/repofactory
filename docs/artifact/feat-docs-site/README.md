# Feature: Documentation site

**Current version:** 3.0.0

## Summary

This feature adds a documentation website to the factory. The website renders the `docs/` tree
of a generated repository and publishes it to GitHub Pages on each push to the default branch. A
project configures a title, a site URL, and a base URL. It can also send deployment messages to
Google Chat, Slack, and Telegram after a successful deployment.

## Current artifacts

- [Requirements](versions/3.0.0/requirements/README.md)
- [Specifications](versions/3.0.0/specifications/README.md)
- [Decisions](versions/3.0.0/decisions/)

## Versions

| Version | Change | Type | Commits |
| --- | --- | --- | --- |
| 1.0.0 | [Initial](changes/change-initial/README.md) | Requirements | 764d326 |
| 2.0.0 | [Send documentation site deployment notifications](changes/change-deployment-notifications/README.md) | Requirements | 443894f..a8c6022 |
| 3.0.0 | [Use multiple deployment notification providers](changes/change-multi-provider-deployment-notifications/README.md) | Requirements | 555ec58 |

Only version 3.0.0 has a folder in `versions/`. The versions before it were folded into
3.0.0 when the artifacts moved to the changes and versions layout. Read the change of each
version for the artifacts of that step.

## Artifacts

- [Changes](changes/), one folder for each change. Read a change for the reason.
- [Versions](versions/), one folder for each version. Read the current version for the state.
