# spec-docs-site-files: Render the documentation site files

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-generated-assets, req-docs-site-azure-pipelines-folder, req-sidebar-feature-order-option
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Per-CI file emission

The value `folder` is `factory.domain.ci-cd.provider.azure-pipelines.folder`. Its default is
`azure-pipelines`.

| Generated path | Condition | Source | Copy mode |
| --- | --- | --- | --- |
| `apps/documentation/package.json` | The site is enabled. | Factory asset | `copy` |
| `apps/documentation/package-lock.json` | The site is enabled. | Factory asset | `copy` |
| `apps/documentation/docusaurus.config.js` | The site is enabled. | Generic factory asset | `copy` |
| `apps/documentation/sidebars.js` | The site is enabled. | Factory asset | `copy` |
| `apps/documentation/site.json` | The site is enabled. | Nix-rendered JSON | `copy` |
| `apps/documentation/.gitignore` | The site is enabled. | Factory asset | `copy` |
| `apps/documentation/src/css/custom.css` | The site is enabled. | Factory asset | `seed` |
| `apps/documentation/README.md` | The site is enabled. | Factory asset | `seed` |
| `docs/wiki/documentation/artifact-driven/docs-site.md` | The site is enabled. | Factory asset | `copy` |
| `.github/workflows/docs-site.yml` | The site is enabled and the CI provider is `github-actions`. | Nix-rendered workflow text | `copy` |
| `${folder}/docs-site.yml` | The site is enabled and the CI provider is `azure-pipelines`. | Nix-rendered pipeline text | `copy` |
| `.github/docs-site/notify.py` | The site is enabled and a notification provider is selected. | Factory asset | `copy` |

The default Azure pipeline path is `azure-pipelines/docs-site.yml`. If the folder is `ci/azure`,
the path is `ci/azure/docs-site.yml`.

The module emits only the pipeline for the selected CI provider. The folder option does not
change a GitHub Actions path or file. The notifier path and bytes are identical on both providers
for the same notification settings.

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
  featureOrder = docsSite.sidebar.feature-order;
}
```

For `title = "Documentation"`, `url = "https://example.github.io"`, and `base-url = "/repo/"`,
the JSON value is equivalent to:

```json
{
  "baseUrl": "/repo/",
  "featureOrder": [],
  "staticDirectories": [],
  "title": "Documentation",
  "url": "https://example.github.io"
}
```

This example shows the data shape. It does not set the option defaults. An implementation check
gets its expected values from its configured inputs and does not encode this example as defaults.

The module always writes `featureOrder`. It keeps the list values and their order without a
change. The factory copy of `docusaurus.config.js` reads `site.featureOrder`. An older
`site.json` file without this field gives an empty list in the Docusaurus configuration.

JSON object key order has no contract meaning. `builtins.toJSON` can write the keys in
alphabetical order. No check compares the JSON text to require a different key order.

The module does not normalize or create a configured static directory. Docusaurus resolves a
relative directory from `apps/documentation/`. A pipeline step or project source supplies the
directory and its files.

### Repository feature-order delivery

The generic factory asset contains no repository-specific feature order. The tracked root
`devenv.nix` module sets this repository's `sidebar.feature-order` value. Nix writes that value to
`site.json.featureOrder`.

The factory copies the same generic asset to this repository and to a downstream repository. It
can overwrite `apps/documentation/docusaurus.config.js` on each shell entry. Thus, an
implementation does not add the repository list to that generated file.

A downstream repository also gets its feature order only through `site.json`. The generic asset
reads the field with `site.featureOrder ?? []`.

### Other file rules

The pinned packages, ignore rules, and optional notifier do not change. The user guide continues
to name `azure-pipelines/docs-site.yml`, which is the default pipeline path. The guide bytes stay
the same as version 7.0.0. This change does not add the sidebar option to the guide asset.

The asset folder contains no `site.json` and no pipeline file. Nix renders these files.

The feature-order change adds no file and changes no copy mode. The Nix evaluation checks add
`featureOrder = []` to both exact JSON round-trip values. Cross-target equality checks continue
to require the field for all publication targets.

The Nix evaluation check can match required text in the generic JavaScript asset. A Docusaurus
build verifies the absent-field default and comparator behavior.

## Description

When the docs-site option is on, the module renders the factory-owned site project, one CI
pipeline, and the guide. The module emits the pipeline file for the selected CI provider only.

`site.json` is the settings boundary between Nix and the authored Docusaurus configuration. The
new `featureOrder` field carries the selected downstream feature order across this boundary.

## Errors

The Azure Pipelines provider domain rejects an empty or invalid folder before the factory emits a
blueprint file. The docs-site composition does not add folder validation.

Nix evaluation fails if an authored source does not exist. Docusaurus fails if a configured
static directory does not exist. A failed generated-asset step stops the build before deployment.
