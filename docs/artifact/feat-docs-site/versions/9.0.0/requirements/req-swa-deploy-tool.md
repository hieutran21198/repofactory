# req-swa-deploy-tool: Offer a deploy tool option for the Static Web App target

**Master:** [Requirements](README.md)
**Covers:** none (new)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must offer a deploy tool option for the documentation site when
the publication target is `azure-static-web-app`. The full option path must
be `factory.composition.artifact-driven.docs-site.azure-static-web-app.deploy-tool`.
The option must accept `official-task` or `swa-cli`. The default value must
be `official-task`. With `official-task`, the generated pipelines must keep
the version 6.1.0 deploy shape. With `swa-cli`, the generated pipelines must
deploy with the self-installed SWA CLI instead of the official task. The
option must apply to GitHub Actions and to Azure Pipelines.

## Acceptance criteria

- Given a project that uses the `azure-static-web-app` target, when the repository maintainer reads the docs-site options, then the maintainer finds one deploy tool option with the values `official-task` and `swa-cli`.
- Given a project that sets no deploy tool, when the factory composes the repository, then the generated pipelines deploy with the official task as in version 6.1.0.
- Given a project that selects `swa-cli`, when the factory composes the repository, then the generated pipelines deploy with the SWA CLI and contain no official Static Web App task.
- Given a value that is not a supported deploy tool, when evaluation runs, then evaluation stops with a message that names the supported deploy tools.

## Notes

The option changes only the deploy mechanism. It does not change the build
output, the deployment target, the notifications, the hooks, or the
extension points. Phase 2 defines the per-provider deploy shapes.
