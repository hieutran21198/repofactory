# Requirements: Documentation site

**Change:** [Add Static Web App deploy tool option](../../../changes/change-swa-deploy-tool-option/README.md)

## Business need

The repository maintainer publishes the documentation site to Azure Static
Web Apps. The Azure Pipelines log shows that the deploy takes about
64 seconds in total. The container pull takes about 27 seconds. The image is
larger than 500 MB, it pulls on each run, and the hosted agents keep no
cache. The zip and upload step takes about 1 second. The build output is
only about 23 MB (about 2.2 MB compressed), it is already minified, and it
has no sourcemaps. The Azure-side polling takes about 32 seconds, and the
factory cannot reduce it.

The maintainer needs a choice of deploy tool for the Static Web App target.
The factory offers a new option with the values `official-task` and
`swa-cli`. The default value is `official-task`, so current projects keep
their behavior. With `swa-cli`, the pipeline installs a factory-pinned SWA
CLI (about 70 MB) and skips the container pull. Conservative users keep the
official task. Both CI providers give the same deployment result for the
same selection. Notifications, hooks, and extension points do not change.

## Scope

- In scope: A new deploy tool option with the values `official-task` and `swa-cli`.
- In scope: The default value `official-task`, which keeps the current behavior.
- In scope: A factory-pinned CLI version with install and cache mapping on both CI providers.
- In scope: The same deploy result on GitHub Actions and on Azure Pipelines for the same selection.
- In scope: The same notifications, hooks, and extension points for both deploy tools.
- In scope: English user documentation for the new option.
- Out of scope: A change to the five artifact-driven phases.
- Out of scope: A change to the site build outputs.
- Out of scope: A guaranteed deployment time (SLO).
- Out of scope: Status fields in any artifact.
- Out of scope: Chat records of the decision process.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, GitHub Actions, Azure Pipelines, docs-site maintainer | Deploy tool selected, site deployed |

The feature touches the aggregate [Repository blueprint](../../../../../domain/context-factory/agg-repository-blueprint.md).

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-browsable-docs](req-browsable-docs.md) | The website must render the whole `docs/` tree, with folder index pages and working relative links. | Must |
| [req-github-pages-publishing](req-github-pages-publishing.md) | A generated workflow must publish the website to GitHub Pages. | Must |
| [req-factory-owned-site](req-factory-owned-site.md) | The factory must own the site project, checks, dependencies, and optional notifier. | Must |
| [req-deployment-notification](req-deployment-notification.md) | Notify a team after the documentation site deploys. | Must |
| [req-multiple-deployment-providers](req-multiple-deployment-providers.md) | Send a deployment notification to all selected providers. | Must |
| [req-generated-assets](req-generated-assets.md) | A downstream repository must add generated static assets through typed extension points. | Must |
| [req-azure-pipelines-publish](req-azure-pipelines-publish.md) | A generated Azure Pipelines pipeline must publish the website to GitHub Pages. | Must |
| [req-azure-static-web-app](req-azure-static-web-app.md) | The factory must publish the website to the selected publication target. | Must |
| [req-swa-deploy-tool](req-swa-deploy-tool.md) | The factory must offer a deploy tool option for the Static Web App target. | Must |
| [req-swa-cli-pinned](req-swa-cli-pinned.md) | The factory must pin the SWA CLI version and install it on both CI providers. | Must |

## Acceptance

The repository maintainer selects a deploy tool for a site that uses the
`azure-static-web-app` target. A project that sets no deploy tool keeps the
official-task behavior of version 6.1.0. A project that selects `swa-cli`
deploys the same build output to the same target on GitHub Actions and on
Azure Pipelines. Notifications, hooks, and extension points work the same
for both deploy tools.
