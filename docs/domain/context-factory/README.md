# context-factory: Repository factory

**Subdomain:** Repository factory
**Type:** Core
**Component:** services/factory

## Purpose

This context combines repository options into a repository blueprint. It decides which files and
working rules the factory supplies to a generated repository.

## Ubiquitous language

| Term | Meaning |
| --- | --- |
| Accepted artifact | A feature artifact on the default branch after a pull request merges. |
| Artifact issue | A project issue that represents one accepted feature artifact file. |
| Repository blueprint | The selected options and generated files for one repository. |
| Provider | An external system that receives artifact issues. |
| Harness | A coding agent product that reads the rendered role files and the skills of a project. |
| Implementation expert | A role that owns phase 4 of the artifact-driven documentation model for one component. |
| Role | An agent persona with one body and one declaration, rendered as one role file for each harness in use. |
| Skill | A folder of instructions that a harness loads on request, copied to each harness in use. |

## Business rules

- The repository is the source of truth for artifacts.
- A rejected artifact proposal does not make a project issue.
- One accepted feature artifact file has one issue in one selected provider.
- A child artifact issue points to its parent artifact issue.
- Provider identifiers do not occur in artifact files.

## Inbound messages

| Message | Kind | From |
| --- | --- | --- |
| Compose repository blueprint | command | Repository maintainer |
| Synchronize accepted artifacts | command | GitHub Actions |

## Outbound messages

| Message | Kind | To |
| --- | --- | --- |
| Repository blueprint composed | event | Repository maintainer |
| Artifact issue synchronized | event | Repository maintainer |

## Aggregates

- [Repository blueprint](agg-repository-blueprint.md)

## Assumptions

- A repository maintainer prepares the external project board before synchronization.

## Open questions

- None.
