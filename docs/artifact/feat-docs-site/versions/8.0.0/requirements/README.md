# Requirements: Documentation site

**Change:** [change-azure-pipelines-folder](../../../changes/change-azure-pipelines-folder/README.md)

## Business need

Repository maintainers use Azure DevOps setups that require a different
pipeline folder. These maintainers need the docs-site pipeline in the same
selected folder as the project-issues pipeline. Today the factory emits the
docs-site pipeline at the fixed path `azure-pipelines/docs-site.yml`. The
trigger in the pipeline also names this fixed path. These maintainers cannot
move the docs-site pipeline to their folder. The factory must emit the
docs-site pipeline in the selected Azure Pipelines folder. The default folder
stays `azure-pipelines`. Existing repositories do not change unless the
maintainer sets the option.

## Scope

- In scope: The docs-site pipeline emission path follows the selected folder.
- In scope: The trigger self-path in the docs-site pipeline follows the selected folder.
- In scope: The default folder stays `azure-pipelines` when the option is unset.
- In scope: The factory rejects an empty or invalid folder value with the existing domain validation.
- Out of scope: A new domain option (the folder option exists).
- Out of scope: A change to the pipeline content except the trigger self-path.
- Out of scope: A change to the project-issues pipeline path.
- Out of scope: A change to GitHub Actions behavior.
- Out of scope: Specifications, decisions, tasks, code, tests, versions.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, Azure Pipelines, docs-site maintainer | Azure Pipelines folder selected, site deployed |

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
| [req-docs-site-azure-pipelines-folder](req-docs-site-azure-pipelines-folder.md) | The factory must emit the docs-site pipeline in the selected Azure Pipelines folder. | Must |

## Acceptance

A repository that leaves the folder option unset keeps the docs-site
pipeline at `azure-pipelines/docs-site.yml`. A repository that sets a custom
folder gets the docs-site pipeline in that folder. The pipeline content stays
the same except the trigger self-path, which uses the selected folder. An
empty or invalid folder value stops generation with a clear error. GitHub
Actions results do not change.
