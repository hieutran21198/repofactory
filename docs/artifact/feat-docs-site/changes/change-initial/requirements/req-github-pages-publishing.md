# req-github-pages-publishing: Publish the website to GitHub Pages

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must generate a GitHub Actions workflow for the documentation site. On each push
to the default branch, the workflow must build the website and publish it to GitHub Pages. After the repository owner sets
the Pages source to "GitHub Actions" one time, no manual step must remain.

## Acceptance criteria

- Given a repository with the documentation site, when the repository maintainer enters the shell, then the repository contains a GitHub Actions workflow for the documentation site.
- Given the Pages source set to "GitHub Actions", when a push reaches the default branch, then the workflow builds the website and publishes it to GitHub Pages without a manual step.
- Given a published website, when a reader opens the site URL, then the reader sees the website that the last push to the default branch built.
- Given a push to a branch that is not the default branch, when the workflow runs, then GitHub Pages keeps the website of the default branch.
- Given a build that fails, when the workflow runs, then GitHub Pages keeps the last published website and the workflow reports the failure.

## Notes

The repository owner sets the Pages source in the repository settings. The factory cannot do
this step, so the factory documents it as the one manual step. The publication target is GitHub
Pages only. A different target is out of scope.
