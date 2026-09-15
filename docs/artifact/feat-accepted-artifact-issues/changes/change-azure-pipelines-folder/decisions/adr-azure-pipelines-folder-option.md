# adr-azure-pipelines-folder-option: Keep the folder option with the Azure Pipelines provider

**Relates to:** spec-ci-cd-provider
**Context:** context-factory

## Context

The factory needs one option for the Azure Pipelines folder. The
project-issues composition uses the option in this change. Other Azure
pipeline producers can use the same option in a later change.

## Options

1. Put `folder` under `domain.ci-cd.provider.azure-pipelines`. Pro: One
   provider option applies to all Azure pipeline producers. Con: Each producer
   must read the provider option.
2. Put `azure-pipelines-folder` under each composition. Pro: Each composition
   owns all its file settings. Con: Multiple compositions can select different
   folders for the same CI provider.
3. Put `folder` directly under `domain.ci-cd.provider`. Pro: The option path is
   shorter. Con: The option exposes an Azure-specific setting to other CI
   providers.

## Decision

Use option 1. The Azure Pipelines provider owns the shared folder setting. The
exact option path is
`factory.domain.ci-cd.provider.azure-pipelines.folder`.

## Consequences

All Azure pipeline producers can use one folder value. The project-issues
composition must read the value from the CI provider domain. GitHub Actions
does not use the value.
