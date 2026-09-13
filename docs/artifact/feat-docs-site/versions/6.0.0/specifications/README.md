# Specifications: Documentation site

**Change:** [Add Azure Static Web App publication target](../../../changes/change-azure-static-web-app/README.md)

## Solution

The docs-site composition keeps the site project, the Docusaurus configuration, the typed extension points, and the pinned tooling. The Docusaurus output under `apps/documentation/build` stays the source on both targets. The composition adds one target option with the values `github-pages` and `azure-static-web-app`. The default stays `github-pages`, so current projects keep their behavior.

Each CI provider supports both targets. The build part of each generated pipeline does not change per target. It keeps the same trigger, the same Node.js 22 build, the same three typed build hooks in list order, and the same watch paths. Only the publish part branches per target. With `github-pages`, each pipeline keeps the version 5.0.0 publish shape. With `azure-static-web-app`, each pipeline uploads the build output with the official Static Web App deploy action or task and the configured deployment token. The same notifier and the same message contract run after a successful deployment to either target. The component is `services/factory` in `context-factory`.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site, target, pipeline, and notification options and assertions for either CI provider. | req-factory-owned-site, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the generated files per CI provider, with shared sources and copy modes. | req-factory-owned-site, req-browsable-docs, req-generated-assets |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Configure Docusaurus to render the docs tree and static directories. | req-browsable-docs, req-generated-assets |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Publish the site to the selected target and add typed workflow extensions. | req-github-pages-publishing, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) | Publish the site to the selected target on Azure Pipelines with the same extensions and notifications. | req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app |
| [spec-azure-static-web-app](spec-azure-static-web-app.md) | Select one publication target and publish the build output to it on both CI providers. | req-azure-static-web-app |
| [spec-eval-checks](spec-eval-checks.md) | Check defaults, targets, typed extensions, files, pipelines, notifications, and assertions on both CI providers. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish, req-azure-static-web-app |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |
| [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) | Define notification delivery for all selected providers. | req-multiple-deployment-providers |

Only the specifications that change are present in this change folder. The table lists every specification at version 6.0.0. The files `spec-docs-site-files.md`, `spec-docusaurus-config.md`, `spec-deployment-notification.md`, and `spec-multiple-deployment-providers.md` do not change and stay as in version 5.0.0.

## Decisions

- [Deploy to Static Web Apps with the official deploy action and task](../decisions/adr-azure-static-web-app-deploy.md)
