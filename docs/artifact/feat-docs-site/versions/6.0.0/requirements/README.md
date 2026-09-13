# Requirements: Documentation site

**Change:** [Add Azure Static Web App publication target](../../../changes/change-azure-static-web-app/README.md)

## Business need

A software team uses the repository factory with the artifact-driven documentation model. The team keeps its authored knowledge as Markdown under `docs/`. The factory publishes that tree as a documentation website on GitHub Pages.

Some repository teams use Azure Pipelines as their CI provider. These teams need the same documentation-site behavior that GitHub Actions provides today. The factory must render the factory-owned site project at `apps/documentation/` when the team selects `azure-pipelines`. The factory must generate an Azure Pipelines pipeline that builds Docusaurus and publishes to GitHub Pages on each push to the default branch. Typed extension points (static directories, watch paths, build steps), pinned tooling, and optional deployment notifications to Google Chat, Slack, and Telegram must work the same on both CI providers.

Some repository teams publish to Azure. These teams need Azure Static Web Apps as a publication target next to GitHub Pages. The repository maintainer selects exactly one publication target through a new docs-site option. The Docusaurus output under `apps/documentation/build` stays the source that the factory publishes. The default target is `github-pages`, so current projects keep their behavior. Both CI providers support both targets.

A downstream repository can also generate documentation assets, such as a PDF from a LaTeX source. The repository must publish these assets with the site. It must also run the tools that generate the assets before Docusaurus builds the site.

The factory owns `docusaurus.config.js` and the docs-site pipeline files. A downstream repository must extend these files through typed options. It must not replace any complete factory-owned file with `lib.mkForce`.

The repository maintainer has made these decisions. They are constraints of this feature:

- The factory delivers the website as a composition option. The option is off by default. A project configures a title, a site URL, and a base URL. Notification settings are optional.
- The maintainer selects exactly one publication target through a new docs-site option. The option accepts `github-pages` or `azure-static-web-app`. The default value is `github-pages`.
- A generated pipeline publishes the website to the selected target on each push to the default branch. The factory generates a GitHub Actions workflow when the team selects `github-actions`. The factory generates an Azure Pipelines pipeline when the team selects `azure-pipelines`.
- The site project lives at `apps/documentation/`. The factory renders it only in the multiple repositories architecture.
- The website renders the `docs/` tree and configured static directories. The factory-owned templates under `docs/wiki/**/templates/` are not published.
- Typed options add pipeline watch paths and build steps at defined points in the factory pipeline.
- The factory pins the dependency versions of the site tooling. A project does not pin them.
- A project can optionally send a deployment message to one or more Google Chat, Slack, and Telegram providers.
- The repository owner makes the Azure preparations outside the factory. The owner creates the Static Web App resource and provides its deployment token.

## Scope

- In scope: One composition option that adds the documentation site to a repository blueprint.
- In scope: A website that renders each Markdown page under `docs/` and configured static assets.
- In scope: One publication target option with the values `github-pages` and `azure-static-web-app`.
- In scope: Typed lists for static directories, pipeline watch paths, and pipeline build steps.
- In scope: A generated GitHub Actions workflow that publishes the website to the selected target.
- In scope: A generated Azure Pipelines pipeline that publishes the website to the selected target.
- In scope: Optional Google Chat, Slack, and Telegram messages after a successful deployment.
- Out of scope: The single repository architecture.
- Out of scope: A ci-cd provider other than `github-actions` or `azure-pipelines`.
- Out of scope: A publication target other than `github-pages` or `azure-static-web-app`.
- Out of scope: More than one publication target for one documentation site.
- Out of scope: Replacement or local overlays for the factory-owned Docusaurus configuration.
- Out of scope: Custom deploy-job extension points.
- Out of scope: Publication of arbitrary source files without a configured static directory.
- Out of scope: A custom visual theme, a search index, or a version selector.

The out-of-scope rule for other ci-cd providers is lifted for `azure-pipelines` only.

The out-of-scope rule for other publication targets is lifted for `azure-static-web-app` only.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, reader, Azure Pipelines | Documentation site enabled, documentation site published on Azure Pipelines, publication target selected, documentation site published on Azure Static Web Apps, deployment notification sent on Azure Pipelines |

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

## Acceptance

A project enables the documentation site with its required domain selections and the CI provider `azure-pipelines`. The generated repository contains the factory-owned site project and the Azure Pipelines pipeline. The project configures a static directory, more watch paths, and build steps. The pipeline generates an asset, copies it into the static directory, builds Docusaurus, and publishes the asset. A project with no extension values gets the same build and deployment behavior as the GitHub Actions pipeline. A project that selects `github-actions` keeps the behavior of version 4.0.3. A project that selects `azure-static-web-app` publishes the website to Azure Static Web Apps on each push to the default branch. A project that sets no publication target publishes the website to GitHub Pages.
