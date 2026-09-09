# Specifications: Documentation site

## Solution

The artifact-driven composition gets one sub-module,
`services/factory/composition/artifact-driven/docs-site/`. The importer `libs/nix/_importer.nix`
finds the module. The module declares the option group
`factory.composition.artifact-driven.docs-site` with site and notification settings. The option is
off by default. When it is on, the module checks the documentation model, repository architecture,
ci-cd provider, and configured values. Then it emits the site files and workflow.

The site tooling is Docusaurus. The factory owns the site project at `apps/documentation/`. The
authored files of the project are assets under `docs-site/_assets/`. Nix writes one settings
file, `apps/documentation/site.json`, from the three option values. The authored
`docusaurus.config.js` reads that file. Nix does not translate a format. This is the pattern of
`services/factory/domain/agent/harness/codex/`.

The Docusaurus docs plugin reads `docs/` of the repository as its content root and serves it at
the root route. A `README.md` is the index page of its folder. Markdown files render as
CommonMark, because three pages have indented code blocks with `<name>` placeholders that MDX
rejects. The plugin excludes `**/templates/**`. A category without an index gets a generated
index page, and each route ends with a slash, so a link to a bare folder opens that index page.

The factory pins the dependency tree with `package.json` and `package-lock.json` in copy mode.
A generated GitHub Actions workflow builds the site with `npm ci` and `npm run build`. It publishes
the build to GitHub Pages with the Pages actions. An optional Python notifier sends one deployment
message to Google Chat or Slack after the deployment succeeds.

A wiki page, `docs/wiki/documentation/artifact-driven/docs-site.md`, tells the repository
maintainer how to run the site locally and how to set the Pages source. It also gives the optional
notification setup and the page rules.

The check file `docs-site/tests/eval.nix` evaluates the module with a stub `lib`. It checks the
files, modes, settings, workflow variants, assertions, and wiki page. Python tests check the
notifier message and delivery behavior.

The component that changes is `services/factory` (context-factory). The aggregate
`agg-repository-blueprint` checks the site and notification configuration. The context adds the
deployment notification event.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the site and notification options and their assertions. | req-factory-owned-site |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the base files, optional notifier, copy modes, sources, and pinned dependencies. | req-factory-owned-site, req-browsable-docs |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Define the settings of `docusaurus.config.js` that render the `docs/` tree with working links. | req-browsable-docs |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Define the GitHub Pages deployment and optional notification steps. | req-github-pages-publishing |
| [spec-eval-checks](spec-eval-checks.md) | Check the module, generated variants, notifier, and assertions. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing |

## Decisions

- [adr-composition-owned-site](../decisions/adr-composition-owned-site.md)
- [adr-pinned-dependencies](../decisions/adr-pinned-dependencies.md)
- [adr-commonmark-and-excluded-templates](../decisions/adr-commonmark-and-excluded-templates.md)
- [adr-trailing-slash](../decisions/adr-trailing-slash.md)
- [Use a dedicated incoming webhook notifier](../changes/change-deployment-notifications/decisions/adr-incoming-webhook-delivery.md)
