# req-factory-owned-site: The factory owns the site project

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must deliver the documentation site as a composition option that is off by default.
A project must configure a title, a site URL, and a base URL. Notification settings are optional.
The factory must render the site project at `apps/documentation/` only in the multiple repositories
architecture. The factory must own the site tooling and optional notifier. The option needs the
artifact-driven documentation model, multiple repositories architecture, and `github-actions`.
Evaluation must stop with a message when the option is on without one of them.

## Acceptance criteria

- Given a project that does not enable the option, when the repository maintainer enters the shell, then the repository contains no site project and no documentation site workflow.
- Given a project with the required model, architecture, and ci-cd provider, when the repository maintainer enables the option with a title, a site URL, and a base URL, then the repository contains the site project at `apps/documentation/`.
- Given the option is on, when the repository maintainer enters the shell, then the website uses the configured title, site URL, and base URL and the maintainer edits no other site file.
- Given the option is on without the artifact-driven documentation model, when evaluation runs, then evaluation stops with a message that names the missing model.
- Given the option is on with the single repository architecture, when evaluation runs, then evaluation stops with a message that names the required architecture.
- Given the option is on without the ci-cd provider `github-actions`, when evaluation runs, then evaluation stops with a message that names the required provider.
- Given two projects with the option on and the same factory version, when the repository maintainers enter their shells, then both repositories use the same dependency versions of the site tooling.
- Given a new factory version with new dependency versions, when the repository maintainer updates the factory, then the repository gets the new versions without a change to the project configuration.
- Given no notification provider, when the repository maintainer enters the shell, then the repository contains no deployment notifier.
- Given Google Chat or Slack, when the repository maintainer enters the shell, then the factory generates the deployment notifier and configured workflow.

## Notes

This repository hosts the factory with the factory, so this repository enables the option too.
The single repository architecture is out of scope for this feature. A later feature can add
it.
