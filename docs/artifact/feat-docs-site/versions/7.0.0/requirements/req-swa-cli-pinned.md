# req-swa-cli-pinned: Pin and install the SWA CLI on both CI providers

**Master:** [Requirements](README.md)
**Covers:** none (new)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must pin the SWA CLI version inside the factory. A project must
not supply the CLI version. When the deploy tool is `swa-cli`, the generated
pipelines must install the pinned CLI on GitHub Actions and on Azure
Pipelines. The install must use a cache when the provider supports it. Both
providers must deploy the same build output to the same target with the same
result. The deployment notifications must work the same as with
`official-task`.

## Acceptance criteria

- Given a project that selects `swa-cli`, when the factory composes the repository, then the generated pipelines install the factory-pinned CLI version and the project configuration names no CLI version.
- Given a project that selects `swa-cli` on `github-actions`, when a push reaches the default branch, then the workflow installs the pinned CLI, deploys the build output to the Static Web App, and sends the same deployment notifications as `official-task`.
- Given a project that selects `swa-cli` on `azure-pipelines`, when a push reaches the default branch, then the pipeline installs the pinned CLI, deploys the build output to the same Static Web App, and sends the same deployment notifications as `official-task`.
- Given a new factory version with a new pinned CLI version, when the repository maintainer updates the factory, then the generated pipelines use the new version without a change to the project configuration.

## Notes

The CLI binary is about 70 MB. It replaces the container pull of more than
500 MB on each run. The Azure-side polling time does not change. Phase 2
defines the pinned version, the install steps, and the cache mapping.
