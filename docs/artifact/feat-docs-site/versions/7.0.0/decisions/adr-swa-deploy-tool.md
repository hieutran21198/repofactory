# adr-swa-deploy-tool: Let the repository maintainer select the Static Web App deploy tool

**Relates to:** spec-swa-deploy-tool, spec-swa-cli-deploy
**Context:** context-factory

## Context

Version 6.1.0 always uses the official Static Web App action or task. The
Azure Pipelines task pulls a container on each hosted run. This pull takes
most of the time that the factory can reduce.

A pinned Static Web Apps CLI skips the container pull. Some maintainers still
prefer the official mechanisms. Both CI providers must give the same result,
and existing projects must keep their current behavior.

## Options

1. Keep only the official action and task. Pro: This keeps the version 6.1.0 shape and the prior decision. Con: A maintainer cannot skip the container pull.
2. Replace the official mechanisms with the CLI. Pro: All projects skip the container pull. Con: This breaks conservative projects and fully reverses `adr-azure-static-web-app-deploy`.
3. Let the maintainer select the tool and default to `official-task`. Pro: Existing projects keep their behavior, and other projects can use the CLI. Con: The factory must own two deploy shapes and their checks.

## Decision

Select option 3. Add one user-selected deploy tool with the default
`official-task`. This option keeps compatibility and gives the faster CLI
path to maintainers who select it.

This decision partially reverses `adr-azure-static-web-app-deploy`. That ADR
still applies to the `official-task` selection. The new CLI contract applies
to the `swa-cli` selection.

## Consequences

The factory owns the CLI version, installation, cache mapping, command flags,
and secret mapping. The project does not own a CLI version setting.

The evaluation checks the default and both enum values. It also checks that
each selection emits exactly one deploy shape on each CI provider. The checks
verify the pin, command, output path, production environment, token mapping,
step order, and unchanged notification shape.
