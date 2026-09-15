# spec-docusaurus-config: Configure Docusaurus to render documentation

**Master:** [Specifications](README.md)
**Covers:** req-browsable-docs, req-generated-assets
**Context:** context-factory

## Description

The authored CommonJS file `docusaurus.config.js` renders the `docs/` tree at the website root. It
reads all project settings from `site.json`. It uses CommonMark for `.md` files, excludes templates,
sorts the sidebar, and makes an index for a folder without `README.md`.

The file also reads the configured static directory list. Thus, downstream repositories can publish
generated files without replacing the factory-owned configuration.

## Contract

The configuration has these project-controlled settings:

| Docusaurus setting | Value |
| --- | --- |
| `title` | `site.title` |
| `url` | `site.url` |
| `baseUrl` | `site.baseUrl` |
| `staticDirectories` | `site.staticDirectories` |

The remaining settings keep the version 3.0.0 contract:

- `trailingSlash` is `true`.
- Both broken-link settings are `warn`.
- Markdown format is `detect`.
- The classic preset disables the blog.
- The docs path is `../../docs` and its route is `/`.
- The sidebar path is `./sidebars.js` and number-prefix parsing is off.
- The exclude list includes the Docusaurus defaults and `**/templates/**`.
- The sidebar generator sorts requirement, decision, specification, and task folders in that order.
- A folder without an index gets a generated index page.
- The classic theme reads `./src/css/custom.css`.
- The navbar title is `site.title`.

`staticDirectories` is an empty list by default. This value keeps the current behavior, which has
no default static directory and no favicon.

## Errors

The build fails if `site.json`, the CSS file, or a configured static directory is absent. Broken
Markdown links produce warnings and do not stop the build.
