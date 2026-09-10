# Change: Initial

**Feature:** [Documentation site](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

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
  project configures a title, a site URL, and a base URL. Notification settings are optional.
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
- A project can optionally send a deployment message to one or more Google Chat, Slack, and Telegram
  providers. The message follows a successful push or manual deployment.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
