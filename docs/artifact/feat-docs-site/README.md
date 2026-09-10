# Feature: Documentation site

**Current version:** 4.0.2

## Summary

This feature adds a documentation website to the factory. The website renders the `docs/` tree
of a generated repository and publishes it to GitHub Pages on each push to the default branch. A
project configures a title, a site URL, and a base URL. It can also send deployment messages to
Google Chat, Slack, and Telegram after a successful deployment. Typed extension points let a
project generate and publish static assets without replacing factory-owned files.

## Current artifacts

- [Requirements](versions/4.0.2/requirements/README.md)
- [Specifications](versions/4.0.2/specifications/README.md)
- [Decisions](versions/4.0.2/decisions/)

## Versions

| Version | Change | Type | Commits |
| --- | --- | --- | --- |
| 1.0.0 | [Initial](changes/change-initial/README.md) | Requirements | 764d326 |
| 2.0.0 | [Send documentation site deployment notifications](changes/change-deployment-notifications/README.md) | Requirements | 443894f..a8c6022 |
| 3.0.0 | [Use multiple deployment notification providers](changes/change-multi-provider-deployment-notifications/README.md) | Requirements | 555ec58 |
| 4.0.0 | [Add generated asset extension points](changes/change-generated-asset-extension-points/README.md) | Requirements | 83da981..29d560b |
| 4.0.1 | [Fix run-only workflow steps](changes/change-run-only-workflow-step/README.md) | Correction | eed7a31..c5654fa |
| 4.0.2 | [Accept workflow step scalars](changes/change-workflow-step-scalars/README.md) | Correction | 81c8083..57b9f0c |

Versions from 3.0.0 have folders in `versions/`. The earlier versions were folded into 3.0.0 when
the artifacts moved to the changes and versions layout. Read each change for the artifacts of that
step.

## Artifacts

- [Changes](changes/), one folder for each change. Read a change for the reason.
- [Versions](versions/), one folder for each version. Read the current version for the state.
