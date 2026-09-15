# adr-docs-site-guide-folder: Keep the default Azure pipeline path in the generated user guide

**Relates to:** spec-docs-site-files
**Context:** context-factory

## Context

The generated docs-site user guide names
`azure-pipelines/docs-site.yml`. This path stays correct when the repository
maintainer uses the default Azure Pipelines folder.

The new contract also supports a custom folder. The requirement changes the
generated pipeline path and its trigger self-path. It does not require a user
guide change.

## Implementation constraints

| Constraint | Owner | Resolution |
| --- | --- | --- |
| The docs-site renderer is outside the module configuration scope. | Factory expert | Pass the selected folder from the composition to the renderer. |
| The Azure Pipelines provider domain owns folder validation. | Factory expert | Reuse the domain assertions and add no docs-site folder assertion. |
| The standalone docs-site test fixture does not contain the folder value. | Factory expert | Add the folder value to the fixture with `azure-pipelines` as its default. |

## Options

1. Keep the guide text at the default path. Pro: The default setup stays
   exact, and the guide bytes do not change. Con: The guide does not explain
   custom-folder setup.
2. Add the folder option and parameterized paths to the guide. Pro: A
   maintainer can follow the guide for a custom folder. Con: The change adds
   guide work that the requirement does not need.

## Decision

Select option 1. Keep the guide text at
`azure-pipelines/docs-site.yml`. This option keeps the default setup exact and
limits this change to the required pipeline contract.

## Consequences

The generated guide stays byte-identical to version 7.0.0. A maintainer who
uses a custom folder must apply the folder value to the pipeline setup path.
A later documentation change can explain the custom-folder setup.
