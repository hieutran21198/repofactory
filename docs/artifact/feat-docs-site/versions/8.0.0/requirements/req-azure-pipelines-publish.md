# req-azure-pipelines-publish: Publish the website with Azure Pipelines

**Master:** [Requirements](README.md)
**Covers:** none (new)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must generate an Azure Pipelines pipeline for the documentation site when the project selects the CI provider `azure-pipelines`. On each push to the default branch, the pipeline must build the website with Docusaurus and publish it to GitHub Pages. The site project, the typed extension points, the pinned tooling, and the optional deployment notifications must work the same as with GitHub Actions. The GitHub Actions behavior must not change.

## Acceptance criteria

- Given a project with the required model, architecture, and CI provider `azure-pipelines`, when the repository maintainer enables the documentation site with a title, a site URL, and a base URL, then the repository contains the factory-owned site project at `apps/documentation/`.
- Given a repository with the documentation site on `azure-pipelines`, when the repository maintainer enters the shell, then the repository contains an Azure Pipelines pipeline for the documentation site.
- Given the Pages source set to "GitHub Actions", when a push reaches the default branch, then the Azure Pipelines pipeline builds the website and publishes it to GitHub Pages without a manual step.
- Given a configured static directory, when the Azure Pipelines pipeline builds the site, then the published site contains the files in that directory.
- Given more pipeline watch paths, when a push changes one of those paths, then the Azure Pipelines pipeline starts.
- Given configured build steps, when the Azure Pipelines pipeline runs, then each step runs at its configured extension point and in list order.
- Given a new factory version with new dependency versions, when the repository maintainer updates the factory, then the Azure Pipelines repository gets the new versions without a change to the project configuration.
- Given one or more Google Chat, Slack, or Telegram providers, when a deployment succeeds on Azure Pipelines, then each selected provider receives one deployment message.
- Given no notification provider, when the factory composes the repository on `azure-pipelines`, then it adds no deployment notifier.
- Given a project that selects `github-actions`, when the factory generates the repository, then the site project and the workflow match the behavior of version 4.0.3.

## Notes

The repository owner sets the Pages source in the repository settings. The factory cannot do this step, so the factory documents it as the one manual step. The publication target is GitHub Pages only. A different target is out of scope. The CI value `azure-pipelines` already exists in the factory. This requirement does not change its meaning.
