# spec-docs-site-files: Render the documentation site files

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-generated-assets, req-docs-site-azure-pipelines-folder
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Per-CI file emission

The value `folder` is
`factory.domain.ci-cd.provider.azure-pipelines.folder`. Its default is
`azure-pipelines`.

| Generated path | Condition | Source |
| --- | --- | --- |
| `.github/workflows/docs-site.yml` | The site is enabled and the CI provider is `github-actions`. | Nix-rendered workflow text |
| `${folder}/docs-site.yml` | The site is enabled and the CI provider is `azure-pipelines`. | Nix-rendered pipeline text |
| `.github/docs-site/notify.py` | The site is enabled and a notification provider is selected. | `./_assets/.github/docs-site/notify.py` |

The default Azure pipeline path is `azure-pipelines/docs-site.yml`. If the
folder is `ci/azure`, the path is `ci/azure/docs-site.yml`.

The module emits no GitHub workflow file when the provider is
`azure-pipelines`. The module emits no Azure pipeline file when the provider
is `github-actions`.

The folder option does not change a GitHub Actions path or file. The notifier
path and bytes are identical on both providers for the same notification
settings.

With the provider `github-actions` and empty extension lists, the generated
workflow text is the same as version 4.0.3.

### `site.json`

The module writes this value with `builtins.toJSON`:

```nix
{
  title = docsSite.title;
  url = docsSite.url;
  baseUrl = docsSite.base-url;
  staticDirectories = docsSite.static-directories;
}
```

With default extension values, the JSON value is equivalent to:

```json
{
  "baseUrl": "/repofactory/",
  "staticDirectories": [],
  "title": "Repository factory",
  "url": "https://example.github.io"
}
```

The module does not normalize or create a configured static directory.
Docusaurus resolves a relative directory from `apps/documentation/`. A
pipeline step or project source supplies the directory and its files.

### Other files

- The factory copies `package.json`, `package-lock.json`,
  `docusaurus.config.js`, `sidebars.js`, `site.json`, `.gitignore`, the
  selected CI pipeline, and the docs-site guide on each shell entry.
- The factory seeds `README.md` and `src/css/custom.css` one time.
- The pinned packages, sidebar behavior, ignore rules, and optional notifier
  do not change.
- The asset folder contains no `site.json` and no pipeline file. Nix renders
  these files.

The user guide documents each extension option. It also gives one complete
LaTeX-to-PDF example. The example configures a static directory, builds a PDF,
copies it, builds Docusaurus, and checks the published build file.

The user guide continues to name `azure-pipelines/docs-site.yml`. This path is
the default path. The guide bytes stay the same as version 7.0.0.

## Description

When the docs-site option is on, the module renders the factory-owned site
project, one CI pipeline, and the guide. The module emits the pipeline file for
the selected CI provider only.

The Azure pipeline path uses the folder from the Azure Pipelines provider
domain. The site sources, copy modes, and optional notifier stay the same on
both providers.

`site.json` remains the settings boundary between Nix and the authored
Docusaurus configuration. Its value does not change.

## Errors

The Azure Pipelines provider domain rejects an empty or invalid folder before
the factory emits a blueprint file. The docs-site composition does not add
folder validation.

Nix evaluation fails if an authored source does not exist. Docusaurus fails if
a configured static directory does not exist when the site build reads it. A
failed generated-asset step stops the build before deployment.

## Notes

The generated user guide keeps the default-path text in this change. A later
documentation change can explain the custom folder option and its setup steps.
