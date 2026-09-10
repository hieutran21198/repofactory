# Specifications: Documentation site

**Change:** [Add generated asset extension points](../../../changes/change-generated-asset-extension-points/README.md)

## Solution

The docs-site composition keeps ownership of the site project and GitHub Actions workflow. It adds
typed lists for static directories, workflow watch paths, and build steps. The module renders the
static directories into `site.json`. The authored Docusaurus configuration reads this value.

The workflow renderer adds watch paths after the factory paths. It adds build steps at three fixed
points. A typed step supports the six fields `name`, `uses`, `with`, `run`, `env`, and
`working-directory`. The module checks the relation between these fields before it renders YAML.

All new options have an empty-list default. Thus, the default Docusaurus and workflow behavior does
not change. The component is `services/factory` in `context-factory`.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site, workflow, and notification options and assertions. | req-factory-owned-site, req-generated-assets |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the generated files, settings, sources, and copy modes. | req-factory-owned-site, req-browsable-docs, req-generated-assets |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Configure Docusaurus to render the docs tree and static directories. | req-browsable-docs, req-generated-assets |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Publish the site and add typed workflow extensions. | req-github-pages-publishing, req-generated-assets |
| [spec-eval-checks](spec-eval-checks.md) | Check defaults, typed extensions, files, workflows, notifications, and assertions. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |
| [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) | Define notification delivery for all selected providers. | req-multiple-deployment-providers |

## Decisions

- [Put the site in a composition sub-module](../decisions/adr-composition-owned-site.md)
- [Pin the Docusaurus dependency tree](../decisions/adr-pinned-dependencies.md)
- [Use CommonMark and exclude templates](../decisions/adr-commonmark-and-excluded-templates.md)
- [Write routes with trailing slashes](../decisions/adr-trailing-slash.md)
- [Use a dedicated incoming webhook notifier](../decisions/adr-incoming-webhook-delivery.md)
