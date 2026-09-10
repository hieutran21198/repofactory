# spec-docs-site-files: Render the documentation site files

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-generated-assets
**Context:** context-factory

## Description

When the docs-site option is on, the module renders the factory-owned site project, workflow, and
guide. The file list, sources, and copy modes stay the same as version 3.0.0. The optional notifier
still exists only when a notification provider is selected.

`site.json` remains the settings boundary between Nix and the authored Docusaurus configuration.
The file gets one more typed value for static directories.

## Contract

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
relative directory from `apps/documentation/`. A workflow step or project source supplies the
directory and its files.

### Other files

- The factory copies `package.json`, `package-lock.json`, `docusaurus.config.js`, `sidebars.js`,
  `site.json`, `.gitignore`, the workflow, and the docs-site guide on each shell entry.
- The factory seeds `README.md` and `src/css/custom.css` one time.
- The pinned packages, sidebar behavior, ignore rules, and optional notifier do not change.
- The asset folder contains no `site.json` or workflow file. Nix renders these two files.

The user guide documents each extension option. It also gives one complete LaTeX-to-PDF example.
The example configures a static directory, builds a PDF, copies it, builds Docusaurus, and checks
the published build file.

## Errors

Nix evaluation fails if an authored source does not exist. Docusaurus fails if a configured static
directory does not exist when the site build reads it. A failed generated-asset step stops the
build before deployment.
