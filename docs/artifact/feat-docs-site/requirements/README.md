# Requirements: Documentation site

## Business need

A software team uses the repository factory with the artifact-driven documentation model. The
team keeps all its knowledge as Markdown under `docs/`: the wiki, the domain model, and the
feature artifacts. Today, nothing publishes that tree. A reader browses raw Markdown on GitHub. A reader
who is not a developer does not find the pages, and a reader who is a developer loses the links
between the pages.

The team needs a documentation website that renders the whole `docs/` tree and that GitHub Pages
serves. The factory must deliver the website, so that each generated repository gets it without
project work. This repository hosts the factory with the factory, so this repository gets the
website too.

The repository maintainer has made these decisions. They are constraints of this feature:

- The factory delivers the website as a composition option. The option is off by default. A
  project configures only a title, a site URL, and a base URL.
- A generated GitHub Actions workflow publishes the website to GitHub Pages on each push to the
  default branch. The feature needs the ci-cd provider `github-actions`. After the repository
  owner sets the Pages source to "GitHub Actions" one time, no manual step remains.
- The site project lives at `apps/documentation/`. The factory renders it only in the multiple
  repositories architecture.
- The website renders the whole `docs/` tree. A `README.md` is the index page of its folder.
  Relative Markdown links between pages continue to work. The factory-owned templates under
  `docs/wiki/**/templates/` are not published.
- The feature needs the artifact-driven documentation model, the multiple repositories
  architecture, and the ci-cd provider `github-actions`. Evaluation must stop with a clear
  message when a project enables the feature without one of them.
- The factory pins the dependency versions of the site tooling. A project does not pin them.

## Scope

- In scope: One composition option that adds the documentation site to a repository blueprint.
- In scope: A website that renders each Markdown page under `docs/`, with a `README.md` as the
  index page of its folder.
- In scope: Relative Markdown links that continue to work on the website.
- In scope: A generated GitHub Actions workflow that publishes the website to GitHub Pages on
  each push to the default branch.
- In scope: An evaluation error when the option is on without the required model, architecture,
  or ci-cd provider.
- In scope: Dependency versions of the site tooling that the factory pins.
- Out of scope: The single repository architecture.
- Out of scope: A ci-cd provider other than `github-actions`.
- Out of scope: A publication target other than GitHub Pages.
- Out of scope: Publication of the templates under `docs/wiki/**/templates/`.
- Out of scope: Publication of content outside `docs/`, for example the source code.
- Out of scope: A custom visual theme, a search index, or a version selector for the website.
- Out of scope: A status or a phase field in any file.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Repository maintainer, reader, GitHub Actions | Documentation site enabled, documentation site published |

The feature touches the aggregate [Repository blueprint](../../../domain/context-factory/agg-repository-blueprint.md).
The documentation site is one more composition that the blueprint activates and checks.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-browsable-docs](req-browsable-docs.md) | The website must render the whole `docs/` tree, with a `README.md` as the index page of its folder and with working relative links. | Must |
| [req-github-pages-publishing](req-github-pages-publishing.md) | A generated workflow must publish the website to GitHub Pages on each push to the default branch. | Must |
| [req-factory-owned-site](req-factory-owned-site.md) | The factory must own the site project, its checks, and its dependency versions; a project configures only a title, a site URL, and a base URL. | Must |

## Acceptance

A project has the artifact-driven documentation model, the multiple repositories architecture,
and the ci-cd provider `github-actions`. The project enables the documentation site option with
a title, a site URL, and a base URL. The generated repository contains the site project at
`apps/documentation/` and a GitHub Actions workflow. After the repository owner sets the Pages
source to "GitHub Actions" one time, a push to the default branch publishes the website. A reader
opens the site URL and finds each page of `docs/` except the templates. Each relative link
between two pages opens the correct page. A project that enables the option without the model,
the architecture, or the ci-cd provider gets a clear evaluation error.
