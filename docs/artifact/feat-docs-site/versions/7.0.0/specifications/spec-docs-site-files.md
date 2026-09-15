# spec-docs-site-files: Render the documentation site files

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-generated-assets
**Context:** context-factory

## Description

When the docs-site option is on, the module renders the factory-owned site project, one CI
pipeline, and the guide. The module emits the pipeline file for the selected CI provider only. The
site sources, the copy modes, and the optional notifier stay the same on both providers.

`site.json` remains the settings boundary between Nix and the authored Docusaurus configuration.
Its value does not change.

## Contract

### Per-CI file emission

| Generated path | Condition | Source |
| --- | --- | --- |
| `.github/workflows/docs-site.yml` | The site is enabled and the CI provider is `github-actions`. | Nix-rendered workflow text |
| `azure-pipelines/docs-site.yml` | The site is enabled and the CI provider is `azure-pipelines`. | Nix-rendered pipeline text |
| `.github/docs-site/notify.py` | The site is enabled and a notification provider is selected. | `./_assets/.github/docs-site/notify.py` |

The module emits no GitHub workflow file when the provider is `azure-pipelines`. The module emits
no Azure pipeline file when the provider is `github-actions`. The notifier path and its bytes are
identical on both providers for the same notification settings.

With the provider `github-actions` and empty extension lists, the generated workflow text is the
same as version 4.0.3.

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

The module does not normalize or create a configured static directory. Docusaurus resolves a
relative directory from `apps/documentation/`. A pipeline step or project source supplies the
directory and its files.

### Other files

- The factory copies `package.json`, `package-lock.json`, `docusaurus.config.js`, `sidebars.js`,
  `site.json`, `.gitignore`, the selected CI pipeline, and the docs-site guide on each shell entry.
- The factory seeds `README.md` and `src/css/custom.css` one time.
- The pinned packages, sidebar behavior, ignore rules, and optional notifier do not change.
- The asset folder contains no `site.json` and no pipeline file. Nix renders these files.

The user guide documents each extension option. It also gives one complete LaTeX-to-PDF example.
The example configures a static directory, builds a PDF, copies it, builds Docusaurus, and checks
the published build file.

## Errors

Nix evaluation fails if an authored source does not exist. Docusaurus fails if a configured static
directory does not exist when the site build reads it. A failed generated-asset step stops the
build before deployment.
