# Specifications: Documentation site

## Solution

The artifact-driven composition gets one sub-module,
`services/factory/composition/artifact-driven/docs-site/`. The importer `libs/nix/_importer.nix`
finds the module. The module declares the option group
`factory.composition.artifact-driven.docs-site` with `enable`, `title`, `url`, and `base-url`.
The option is off by default. When it is on, the module checks the documentation model, the
repository architecture, the ci-cd provider, and the three values. Then it emits ten files.

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
A generated GitHub Actions workflow builds the site with `npm ci` and `npm run build` on each
push to the default branch and publishes the build to GitHub Pages with the Pages actions.

A wiki page, `docs/wiki/documentation/artifact-driven/docs-site.md`, tells the repository
maintainer how to run the site locally, how to set the Pages source one time, and how to write
a page that renders.

The check file `docs-site/tests/eval.nix` evaluates the module with a stub `lib`. It checks the
files, the modes, the settings, the workflow, the assertions, and the wiki page.

The component that changes is `services/factory` (context-factory). The aggregate
`agg-repository-blueprint` gets one invariant: an enabled documentation site composition needs
the artifact-driven model, the multiple repositories architecture, and GitHub Actions. The
messages of the context do not change.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-docs-site-options](spec-docs-site-options.md) | Declare the option group, its defaults, and the assertions of the docs-site module. | req-factory-owned-site |
| [spec-docs-site-files](spec-docs-site-files.md) | Define the ten generated files, their copy modes, their sources, and the pinned dependency files. | req-factory-owned-site, req-browsable-docs |
| [spec-docusaurus-config](spec-docusaurus-config.md) | Define the settings of `docusaurus.config.js` that render the `docs/` tree with working links. | req-browsable-docs |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Define the GitHub Actions workflow that builds and publishes the site to GitHub Pages. | req-github-pages-publishing |
| [spec-eval-checks](spec-eval-checks.md) | Check the module, the files, the settings, and the assertions in the module evaluation. | req-factory-owned-site, req-browsable-docs, req-github-pages-publishing |

## Decisions

- [adr-composition-owned-site](../decisions/adr-composition-owned-site.md)
- [adr-pinned-dependencies](../decisions/adr-pinned-dependencies.md)
- [adr-commonmark-and-excluded-templates](../decisions/adr-commonmark-and-excluded-templates.md)
- [adr-trailing-slash](../decisions/adr-trailing-slash.md)
