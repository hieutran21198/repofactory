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
| Acceptance notification | One team message that summarizes accepted artifact changes from a merged pull request. |
| Artifact issue | A project issue that represents one accepted feature artifact file. |
| Repository blueprint | The selected options and generated files for one repository. |
| Provider | An external system that receives artifact issues. |
| Harness | A coding agent product that reads the rendered role files and the skills of a project. |
| Implementation expert | A role that owns phase 4 of the artifact-driven documentation model for one component. |
| Role | An agent persona with one body and one declaration, rendered as one role file for each harness in use. |
| Skill | A folder of instructions that a harness loads on request, copied to each harness in use. |
| Documentation site | A website that renders the `docs/` tree of a generated repository and that GitHub Pages serves. |
| Generated documentation asset | A file that a workflow makes and adds to a documentation site static directory. |
| Deployment notification | One team message that reports a successful documentation site deployment. |
| Notification provider | An external system that receives a team notification. |
| Change | One unit of work on a feature. It holds the reason and the artifacts that change. |
| Version | The full requirements, specifications, and decisions of a feature after one change, named major.minor.patch. |
| Current version | The version that the feature README names. |
| Change type | The kind of a change: Requirements, Specifications, Decisions, or Correction. |

## Business rules

- The repository is the source of truth for artifacts.
- A rejected artifact proposal does not make a project issue.
- One accepted feature artifact file has one issue in one selected provider.
- A child artifact issue points to its parent artifact issue.
- Provider identifiers do not occur in artifact files.
- An acceptance notification follows successful artifact issue synchronization.
- A deployment notification follows a successful documentation site deployment.
- A documentation site extension adds generated assets without replacing a factory-owned file.
- A notification can use one or more supported notification providers.
- Each unit of work on a feature is a change. The first change of a feature is `change-initial`.
- A version is produced by copy only. A file under `versions/` is never edited.
- A file under `versions/` does not make an artifact issue.

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
| Acceptance notification sent | event | Repository maintainer |
| Deployment notification sent | event | Repository maintainer |

## Aggregates

- [Repository blueprint](agg-repository-blueprint.md)

## Assumptions

- A repository maintainer prepares the external project board before synchronization.

## Open questions

- None.
