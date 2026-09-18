# Feature: Documentation site

**Current version:** 9.0.0

## Summary

This feature adds a documentation website to the factory. The website renders the `docs/` tree
of a generated repository and publishes it to the selected publication target on each push to the default branch. The default target is GitHub Pages. A project can select Azure Static Web Apps instead. A
project configures a title, a site URL, and a base URL. It can also send deployment messages to
Google Chat, Slack, and Telegram after a successful deployment. Typed extension points let a
project generate and publish static assets without replacing factory-owned files.

## Current artifacts

- [Requirements](versions/9.0.0/requirements/README.md)
- [Specifications](versions/9.0.0/specifications/README.md)
- [Decisions](versions/9.0.0/decisions/)

## Versions

| Version | Change | Type | Commits |
| --- | --- | --- | --- |
| 1.0.0 | [Initial](changes/change-initial/README.md) | Requirements | 764d326 |
| 2.0.0 | [Send documentation site deployment notifications](changes/change-deployment-notifications/README.md) | Requirements | 443894f..a8c6022 |
| 3.0.0 | [Use multiple deployment notification providers](changes/change-multi-provider-deployment-notifications/README.md) | Requirements | 555ec58 |
| 4.0.0 | [Add generated asset extension points](changes/change-generated-asset-extension-points/README.md) | Requirements | 83da981..29d560b |
| 4.0.1 | [Fix run-only workflow steps](changes/change-run-only-workflow-step/README.md) | Correction | eed7a31..c5654fa |
| 4.0.2 | [Accept workflow step scalars](changes/change-workflow-step-scalars/README.md) | Correction | 81c8083..57b9f0c |
| 4.0.3 | [Fix workflow watch path indentation](changes/change-workflow-watch-path-indent/README.md) | Correction | bbdc9be..1d441f5 |
| 5.0.0 | [Add Azure Pipelines provider](changes/change-azure-pipelines-provider/README.md) | Requirements |  |
| 6.0.0 | [Add Azure Static Web App publication target](changes/change-azure-static-web-app/README.md) | Requirements |  |
| 6.1.0 | [Point SWA app_location at build output](changes/change-swa-app-location/README.md) | Specifications |  |
| 7.0.0 | [Add Static Web App deploy tool option](changes/change-swa-deploy-tool-option/README.md) | Requirements |  |
| 8.0.0 | [Azure Pipelines folder for the docs-site pipeline](changes/change-azure-pipelines-folder/README.md) | Requirements |  |
| 9.0.0 | [Sidebar sort order](changes/change-sidebar-sort-order/README.md) | Requirements |  |

Versions from 3.0.0 have folders in `versions/`. The earlier versions were folded into 3.0.0 when
the artifacts moved to the changes and versions layout. Read each change for the artifacts of that
step.

## Artifacts

- [Changes](changes/), one folder for each change. Read a change for the reason.
- [Versions](versions/), one folder for each version. Read the current version for the state.
