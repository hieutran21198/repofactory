# req-azure-static-web-app: Publish the website to the selected target

**Master:** [Requirements](README.md)
**Covers:** none (new)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must let the repository maintainer select exactly one publication
target for the documentation site through a new docs-site option. The option
must accept `github-pages` or `azure-static-web-app`. The default value must
be `github-pages`. The Docusaurus output under `apps/documentation/build`
must stay the source that the factory publishes. On each push to the default
branch, the generated pipeline must build the website and publish it to the
selected target. The site project, the typed extension points, the pinned
tooling, and the optional deployment notifications must work the same on both
targets. Both CI providers must support both targets.

## Acceptance criteria

- Given a project with the documentation site, when the repository maintainer
  reads the docs-site option, then the maintainer finds one publication target
  option with the values `github-pages` and `azure-static-web-app`.
- Given a project that sets no publication target, when the factory composes
  the repository, then the factory publishes the website to GitHub Pages.
- Given a project that selects `azure-static-web-app`, when the factory
  composes the repository, then the generated pipeline publishes the website
  to Azure Static Web Apps and not to GitHub Pages.
- Given a project that selects `github-actions` with `azure-static-web-app`,
  when a push reaches the default branch, then the workflow builds the website
  and publishes it to Azure Static Web Apps.
- Given a project that selects `azure-pipelines` with `azure-static-web-app`,
  when a push reaches the default branch, then the pipeline builds the website
  and publishes it to Azure Static Web Apps.
- Given a project that selects `github-pages`, when the factory generates the
  repository, then the site project and the pipeline match the behavior of
  version 5.0.0.
- Given a configured static directory, when the pipeline builds the site for
  `azure-static-web-app`, then the published site contains the files in that
  directory.
- Given configured build steps, when the pipeline runs for
  `azure-static-web-app`, then each step runs at its configured extension
  point and in list order.
- Given one or more Google Chat, Slack, or Telegram providers, when a
  deployment to Azure Static Web Apps succeeds, then each selected provider
  receives one deployment message.
- Given a value that is not a supported target, when evaluation runs, then
  evaluation stops with a message that names the supported targets.

## Notes

The repository owner makes the Azure preparations outside the factory. The
owner creates the Static Web App resource and provides its deployment token.
The factory cannot do these steps, so the factory documents them as manual
steps. Phase 2 defines how the generated pipeline reads the deployment token.
