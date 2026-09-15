# Specifications: Documentation site

**Change:** [Add Static Web App deploy tool option](../../../changes/change-swa-deploy-tool-option/README.md)

## Solution

The `services/factory` component adds one deploy tool option for the
`azure-static-web-app` target. The option selects `official-task` or
`swa-cli`. Its default is `official-task`, which keeps the version 6.1.0
pipeline shape.

The `swa-cli` selection installs the factory-pinned Static Web Apps CLI on
both CI providers. Both providers upload `apps/documentation/build` to the
production environment. Both providers use the configured deployment token.
The notification step stays after the deploy step.

GitHub Actions uses the npm cache from `actions/setup-node@v4`. Azure
Pipelines adds one `Cache@2` task for the npm cache. The Azure cache serves
both `npm ci` and the CLI installation. The `github-pages` target, build
hooks, extension points, and notifications do not change.

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
| [spec-swa-deploy-tool](spec-swa-deploy-tool.md) | Select one Static Web App deploy tool for both CI providers. | req-swa-deploy-tool |
| [spec-swa-cli-deploy](spec-swa-cli-deploy.md) | Install the pinned CLI and deploy the site build output on both CI providers. | req-swa-deploy-tool, req-swa-cli-pinned |

Only the two new specifications are present in this change folder. The table
lists every specification at version 7.0.0.

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
