# Specifications: Documentation site

**Change:** [change-sidebar-sort-order](../../../changes/change-sidebar-sort-order/README.md)

## Solution

The `services/factory` component adds one typed feature-order option to the docs-site
composition. The option is
`factory.composition.artifact-driven.docs-site.sidebar.feature-order`. It is a list of
feature folder basenames. The default value is an empty list.

The composition writes the selected list to `site.json` as `featureOrder`. The factory copy of
`docusaurus.config.js` reads this field. If the field is absent, the configuration uses an empty
list. Thus, an older `site.json` file keeps alphabetical feature order.

The Docusaurus configuration applies one comparator at each sidebar level. The comparator puts
index pages first. It also sorts artifact phases, versions, changes, and feature folders by their
specified rules. It uses a case-insensitive display-label order for all remaining items.

This repository sets its dependency order through the typed option in the tracked root
`devenv.nix` module. The list uses actual `feat-*` folder basenames. The factory renders the list
into `site.json`. The generic configuration reads the list as `FEATURE_ORDER`.

The change adds one invariant to the Repository blueprint aggregate. An enabled feature-order
list contains unique, non-empty feature folder basenames. The aggregate pattern stays `Domain
model`. The context messages and the context map do not change.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site, sidebar, target, pipeline, and notification options and assertions for either CI provider. | req-factory-owned-site, req-generated-assets, req-azure-static-web-app, req-sidebar-feature-order-option |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the generated files, the `site.json` data, and the selected Azure Pipelines folder. | req-factory-owned-site, req-browsable-docs, req-generated-assets, req-docs-site-azure-pipelines-folder, req-sidebar-feature-order-option |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Configure Docusaurus and sort each sidebar level in the specified order. | req-browsable-docs, req-generated-assets, req-sidebar-sort-order, req-sidebar-feature-order-option |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Publish the site to the selected target and add typed workflow extensions. | req-github-pages-publishing, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) | Publish the site on Azure Pipelines and use the selected folder in the file path and trigger. | req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-azure-static-web-app](spec-azure-static-web-app.md) | Select one publication target and publish the build output through the selected CI provider. | req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-eval-checks](spec-eval-checks.md) | Check defaults, custom folders, invalid folders, files, pipelines, targets, and unchanged GitHub Actions output. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish, req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |
| [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) | Define notification delivery for all selected providers. | req-multiple-deployment-providers |
| [spec-swa-deploy-tool](spec-swa-deploy-tool.md) | Select one Static Web App deploy tool for both CI providers. | req-swa-deploy-tool |
| [spec-swa-cli-deploy](spec-swa-cli-deploy.md) | Install the pinned CLI and deploy the site build output on both CI providers. | req-swa-deploy-tool, req-swa-cli-pinned |

The table lists every specification after this change. This change contains the three
replacement specifications that define the sidebar order and its data path.

## Decisions

- [Put the site in a composition sub-module](../decisions/adr-composition-owned-site.md)
- [Render CommonMark and exclude the templates](../decisions/adr-commonmark-and-excluded-templates.md)
- [Use a dedicated incoming webhook notifier](../decisions/adr-incoming-webhook-delivery.md)
- [Ship the lockfile in copy mode](../decisions/adr-pinned-dependencies.md)
- [Reuse one site builder and one notifier across both CI systems](../decisions/adr-shared-site-implementation.md)
- [Add a trailing slash to each route](../decisions/adr-trailing-slash.md)
- [Map secret names one to one onto Azure secret variables](../decisions/adr-azure-secret-mapping.md)
- [Deploy to Static Web Apps with the official deploy action and task](../decisions/adr-azure-static-web-app-deploy.md)
- [Let the repository maintainer select the Static Web App deploy tool](../decisions/adr-swa-deploy-tool.md)
- [Keep the default Azure pipeline path in the generated user guide](../decisions/adr-docs-site-guide-folder.md)
- [Use actual feature folder basenames](../decisions/adr-feature-order-identifiers.md)
