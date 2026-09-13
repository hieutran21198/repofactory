# req-browsable-docs: Render the docs tree as a website

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The documentation site must render each Markdown page under `docs/` as a web page. A `README.md`
must be the index page of its folder. A relative Markdown link between two pages must open the
correct page on the website. The templates under `docs/wiki/**/templates/` must not appear on
the website.

## Acceptance criteria

- Given a repository with the documentation site, when a reader opens the site URL, then the reader sees the content of `docs/README.md` as the home page.
- Given a folder under `docs/` with a `README.md`, when a reader opens the page of that folder, then the reader sees the content of that `README.md`.
- Given a Markdown page under `docs/` that is not a template, when a reader browses the website, then the reader can reach a page with the content of that file.
- Given a page with a relative link to another Markdown page, when a reader selects the link, then the website opens the page of the linked file.
- Given a relative link to a `README.md`, when a reader selects the link, then the website opens the index page of that folder.
- Given a file under `docs/wiki/**/templates/`, when a reader browses the website, then the reader does not find a page for that file.
- Given a new Markdown page added under `docs/`, when the website publishes again, then the reader finds the new page without a change to the site configuration.

## Notes

The `docs/` tree is the source. An author writes Markdown and does not edit the website. A
`README.md` is the index page because the artifact-driven model and the domain model both use
`README.md` as the entry point of a folder.
