# Specifications: Documentation site

**Change:** [change-azure-pipelines-folder](../../../changes/change-azure-pipelines-folder/README.md)

## Solution

The `services/factory` component uses the existing Azure Pipelines folder
option for the docs-site pipeline. The option is
`factory.domain.ci-cd.provider.azure-pipelines.folder`. Its default value is
`azure-pipelines`.

The docs-site composition passes the selected folder to the Azure pipeline
renderer. It uses the same folder for the generated file path and the trigger
self-path. The factory emits the pipeline at `${folder}/docs-site.yml`.

The Azure Pipelines provider domain keeps ownership of the folder option and
its validation. The docs-site composition adds no option and no duplicate
validation. A folder change changes only the generated Azure pipeline path and
its trigger self-path. GitHub Actions output does not change.

The generated user guide continues to name the default
`azure-pipelines/docs-site.yml` path. The guide content does not change in this
change. The reason is in
[adr-docs-site-guide-folder](../decisions/adr-docs-site-guide-folder.md).

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site, target, pipeline, and notification options and assertions for either CI provider. | req-factory-owned-site, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the generated files per CI provider, including the selected Azure Pipelines folder. | req-factory-owned-site, req-browsable-docs, req-generated-assets, req-docs-site-azure-pipelines-folder |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Configure Docusaurus to render the docs tree and static directories. | req-browsable-docs, req-generated-assets |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Publish the site to the selected target and add typed workflow extensions. | req-github-pages-publishing, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) | Publish the site on Azure Pipelines and use the selected folder in the file path and trigger. | req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-azure-static-web-app](spec-azure-static-web-app.md) | Select one publication target and publish the build output through the selected CI provider. | req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-eval-checks](spec-eval-checks.md) | Check defaults, custom folders, invalid folders, files, pipelines, targets, and unchanged GitHub Actions output. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish, req-azure-static-web-app, req-docs-site-azure-pipelines-folder |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |
| [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) | Define notification delivery for all selected providers. | req-multiple-deployment-providers |
| [spec-swa-deploy-tool](spec-swa-deploy-tool.md) | Select one Static Web App deploy tool for both CI providers. | req-swa-deploy-tool |
| [spec-swa-cli-deploy](spec-swa-cli-deploy.md) | Install the pinned CLI and deploy the site build output on both CI providers. | req-swa-deploy-tool, req-swa-cli-pinned |

The table lists every specification at version 8.0.0. This change contains the
four replacement specifications that define and check the folder behavior.

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
