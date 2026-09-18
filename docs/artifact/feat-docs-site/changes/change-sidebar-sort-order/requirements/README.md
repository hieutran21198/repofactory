# Requirements: Documentation site

**Change:** [change-sidebar-sort-order](../../../changes/change-sidebar-sort-order/README.md)

## Business need

Documentation readers browse the generated site and use the sidebar to find pages. Today the
sidebar lists pages in no clear order: index pages do not come first, decision folders appear
before specification folders, versions do not follow version order, and feature folders follow
alphabetical order instead of the dependency path. Readers cannot find pages by position and
cannot trust the order that the sidebar shows.

Repository maintainers need a deterministic sidebar sort order on every generated site: index
pages first, artifact phases in phase order, versions newest first, `change-initial` first with
the remaining changes alphabetical, other pages alphabetical by display label, and feature
folders in dependency path order. Downstream projects also need a typed option to define their
own feature order, rendered into `site.json` for the site configuration to read, with unlisted
folders kept in alphabetical order.

## Scope

- In scope: The deterministic sort order of each sidebar level (index first, phase order, version order, change order, alphabetical order, feature order).
- In scope: The correction of the phase order so specifications come before decisions.
- In scope: The explicit feature order list of this repository in dependency path order.
- In scope: The generic sort rules in the factory copy for downstream projects.
- In scope: The new typed `sidebar.feature-order` option (list of strings, default empty) rendered into `site.json`.
- Out of scope: A change to the site content, the site style, or the publication targets.
- Out of scope: A change to the pipelines, the notifications, or the generated assets.
- Out of scope: Specifications, decisions, tasks, code, tests, versions.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, Documentation reader | Sidebar sort order applied, Feature order selected, site deployed |

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
| [req-sidebar-sort-order](req-sidebar-sort-order.md) | The documentation site must sort each sidebar level in a deterministic order. | Must |
| [req-sidebar-feature-order-option](req-sidebar-feature-order-option.md) | The factory must offer a typed docs-site option for the sidebar feature order. | Must |

## Acceptance

A reader finds the index page first in each sidebar level, artifact phases in phase order with
specifications before decisions, versions newest first, `change-initial` first with the
remaining changes alphabetical, other pages alphabetical by display label, and feature folders
in the dependency path order. A project that leaves the new option unset keeps alphabetical
feature order. A project that sets the option sees listed folders in list order and unlisted
folders alphabetical after them. A value of the wrong type stops evaluation with a type error.
