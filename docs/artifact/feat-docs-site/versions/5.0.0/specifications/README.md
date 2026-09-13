# Specifications: Documentation site

**Change:** [Add Azure Pipelines provider](../../../changes/change-azure-pipelines-provider/README.md)

## Solution

The docs-site composition keeps the site project, the Docusaurus configuration, and the GitHub Actions workflow. The GitHub workflow bytes do not change. The composition accepts one more CI provider value. When the project selects `azure-pipelines`, the composition emits one Azure pipeline at `azure-pipelines/docs-site.yml` and emits no GitHub workflow. When the project selects `github-actions`, the emitted files match version 4.0.3.

The Azure pipeline runs the same build with the same pinned tooling. It maps the same three typed build hooks and the same watch paths onto Azure syntax. It reuses the same notifier script and the same message contract. Each secret name maps one to one onto an Azure secret variable. The component is `services/factory` in `context-factory`.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site, pipeline, and notification options and assertions for either CI provider. | req-factory-owned-site, req-generated-assets |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the generated files per CI provider, with shared sources and copy modes. | req-factory-owned-site, req-browsable-docs, req-generated-assets |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Configure Docusaurus to render the docs tree and static directories. | req-browsable-docs, req-generated-assets |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Publish the site and add typed workflow extensions. | req-github-pages-publishing, req-generated-assets |
| [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) | Publish the site on Azure Pipelines with the same extensions and notifications. | req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers |
| [spec-eval-checks](spec-eval-checks.md) | Check defaults, typed extensions, files, pipelines, notifications, and assertions on both CI providers. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |
| [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) | Define notification delivery for all selected providers. | req-multiple-deployment-providers |

## Decisions

- [Reuse one site builder and one notifier across both CI systems](../decisions/adr-shared-site-implementation.md)
- [Map secret names one to one onto Azure secret variables](../decisions/adr-azure-secret-mapping.md)
