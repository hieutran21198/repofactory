# adr-trailing-slash: Add a trailing slash to each route

**Relates to:** spec-docusaurus-config
**Context:** context-factory

## Context

Docusaurus rewrites a Markdown link to a file path, for example `](decisions/adr-y.md)`, to the
route of that file at build time. It does not rewrite a link to a URL path, for example
`](decisions/)`. The browser resolves such a link against the URL of the current page. Nine feature
and change summaries under `docs/artifact/` link to a bare folder, `](decisions/)` or `](changes/)`.
The sidebar generator of `spec-docusaurus-config` gives each of these folders a generated index
page at the route of the folder. The link must resolve to that route.

The `trailingSlash` setting of Docusaurus controls the form of each route and the name of each
emitted HTML file. GitHub Pages serves `<folder>/index.html` for a URL that ends with `/`, and
serves `<name>.html` for a URL without an extension.

## Options

1. Set `trailingSlash: true`. Each route ends with `/`, and the build writes
   `<route>/index.html`. Pro: from `/artifact/feat-x/`, the link `decisions/` resolves to
   `/artifact/feat-x/decisions/`, which is the generated index of that folder. Pro: the routes
   are the same as the folder URLs that GitHub Pages serves, so no redirect occurs. Con: each
   URL has one more character.
2. Set `trailingSlash: false`. Each route has no trailing `/`, and the build writes
   `<route>.html`. Pro: short URLs. Con: from `/artifact/feat-x`, the link `decisions/`
   resolves to `/artifact/decisions/`, which does not exist. The nine folder links break, and
   the generated index pages have no link that reaches them.
3. Set `trailingSlash: false` and change the nine summaries to link a file, for example
   `](decisions/README.md)`. Pro: file links are stable under both settings. Con: the folders
   `decisions/` and `changes/` have no `README.md`, so the link target does not exist; the
   feature would need a new `README.md` in each of these folders and in each future feature.
   Con: the feature template `templates/feature/README.md` and the artifacts of five features
   change.

## Decision

Option 1. A trailing slash makes the existing folder links resolve to the generated index
pages without a change to any page.

## Consequences

The check `configMatches` in `tests/eval.nix` matches `trailingSlash: true`. The route table of
`spec-docusaurus-config` gives each route with a trailing `/`. The wiki page `docs-site.md`
still tells an author to link a `README.md` file rather than a bare folder, because a file link
is stable and works on GitHub too. An author who writes a URL-path link must end a folder link
with `/`.
