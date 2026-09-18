# adr-commonmark-and-excluded-templates: Render CommonMark and exclude the templates

**Relates to:** spec-docusaurus-config
**Context:** context-factory

## Context

Docusaurus 3 parses each `.md` file as MDX by default. MDX reads `<name>` as a JSX tag and
stops the build on a bare placeholder. The `docs/` tree of this repository has two kinds of
pages that MDX rejects:

- Three pages have 4-space indented code blocks with `<name>` placeholders:
  `docs/wiki/documentation/artifact-driven/README.md`, `docs/wiki/design/ddd/README.md`, and
  `docs/artifact/feat-ddd-design/specifications/spec-domain-templates.md`. MDX does not treat
  an indented block as code, so it parses the placeholders as JSX.
- The 19 template files under `docs/wiki/documentation/artifact-driven/templates/` and
  `docs/wiki/design/ddd/templates/` have bare `<name>` placeholders in prose. A CommonMark
  parser drops them as unknown HTML, so the pages render with missing words. The templates are
  copy-mode factory files that no page links to.

The requirement `req-browsable-docs` says that the templates must not appear on the website.
The requirement also says that a new page renders without a change to the site configuration.

## Options

1. Set `markdown.format` to `detect`, so that `.md` files render as CommonMark and `.mdx` files
   render as MDX, and add `**/templates/**` to the `exclude` list of the docs plugin. Pro: the
   three pages with indented code blocks render as the author wrote them. Pro: an author writes
   plain Markdown and does not learn MDX. Pro: the templates do not appear, as the requirement
   says. Con: a page cannot use a React component unless the author renames it to `.mdx`.
   Con: an author who writes a bare `<name>` in prose gets a page with a missing word and no
   error; the wiki page tells the author to put a placeholder in backticks.
2. Keep the MDX format and fix each page: change the indented code blocks to fenced blocks and
   put each placeholder in the templates in backticks or escape it. Pro: no format setting.
   Con: the three pages and the 19 templates are factory assets, so each fix is a change to a
   shipped file and to the expected content of a check. Con: each new page that an author
   writes must be MDX-safe, and the build stops on the first bare `<name>`.
3. Keep the MDX format and exclude the three pages and the templates. Pro: no page changes.
   Con: the two guide pages and one specification vanish from the website, which breaks the
   requirement that each page under `docs/` that is not a template renders.

## Decision

Option 1. CommonMark renders the pages as the author wrote them, and the `exclude` entry meets
the requirement that the templates do not appear.

## Consequences

The docs plugin restates the default `exclude` entries and adds `**/templates/**`, because a
custom list replaces the default list. An author who needs MDX renames one file to `.mdx`. The
wiki page `docs-site.md` tells an author to put a placeholder in backticks and to link a
`README.md` rather than a bare folder. The site also gives each category without an index a
generated index page, and `adr-trailing-slash` makes the existing links to bare folders such as
`decisions/` resolve to that page.
`onBrokenLinks` and `onBrokenMarkdownLinks` are `warn`, so a broken link does not stop the
build; the task `task-verify-generation` reviews the warnings.
