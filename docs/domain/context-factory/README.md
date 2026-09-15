# context-factory: Repository factory

**Subdomain:** Repository factory
**Type:** Core
**Component:** services/factory

## Purpose

This context combines repository options into a repository blueprint. It decides which files and
working rules the factory supplies to a generated repository. It also holds the rule that each
provider component owns a machine-readable contract for its wire surface.

## Ubiquitous language

| Term | Meaning |
| --- | --- |
| Accepted artifact | A feature artifact on the default branch after a pull request merges. |
| Artifact master | The coordinator that controls one artifact-driven change and routes each phase to its owner. |
| Acceptance notification | One team message that summarizes accepted artifact changes from a merged pull request. |
| Artifact issue | A project issue that represents one accepted feature artifact file. |
| Azure Pipelines | An Azure DevOps CI provider that runs factory workflows. |
| Repository blueprint | The selected options and generated files for one repository. |
| Provider | An external system that receives artifact issues. |
| Harness | A coding agent product that reads the rendered role files and the skills of a project. |
| Implementation expert | A role that owns phase 4 of the artifact-driven documentation model for one component. |
| Role | An agent persona with one body and one declaration, rendered as one role file for each harness in use. |
| Skill | A folder of instructions that a harness loads on request, copied to each harness in use. |
| Mixture of experts | The harness roles that artifact-driven uses: the artifact master for coordination plus the requirement, solution, and implementation experts for phase content, with routing between them. |
| Documentation site | A website that renders the `docs/` tree of a generated repository and that the selected publication target serves. |
| Publication target | The hosting service that serves the documentation site, `github-pages` or `azure-static-web-app`. One site uses one target. |
| Azure Static Web App | An Azure hosting service that serves static websites. It is one publication target of the documentation site. |
| Generated documentation asset | A file that a workflow makes and adds to a documentation site static directory. |
| Deployment notification | One team message that reports a successful documentation site deployment. |
| Notification provider | An external system that receives a team notification. |
| Phase handoff | A short report of a completed phase build and the input for the next phase. |
| Phase plan | A read-only proposal that defines one phase build and waits for user approval. |
| Change | One unit of work on a feature. It holds the reason and the artifacts that change. |
| Version | The full requirements, specifications, and decisions of a feature after one change, named major.minor.patch. |
| Current version | The version that the feature README names. |
| Change type | The kind of a change: Requirements, Specifications, Decisions, or Correction. |
| Provider contract | A machine-readable description of the wire surface of one component, owned by the provider team. |
| Consumer team | A team that uses the wire surface of a provider component. |
| Breaking change | A contract change that forces a consumer team to change its code. |

## Business rules

- The repository is the source of truth for artifacts.
- A rejected artifact proposal does not make a project issue.
- An accepted artifact sync runs on the selected CI provider (github-actions or azure-pipelines) with the same result.
- One accepted feature artifact file has one issue in one selected provider.
- A child artifact issue points to its parent artifact issue.
- Provider identifiers do not occur in artifact files.
- An acceptance notification follows successful artifact issue synchronization.
- A deployment notification follows a successful documentation site deployment.
- A documentation site publishes to exactly one publication target.
- The publication target is `github-pages` unless the maintainer selects `azure-static-web-app`.
- A documentation site extension adds generated assets without replacing a factory-owned file.
- A notification can use one or more supported notification providers.
- Each unit of work on a feature is a change. The first change of a feature is `change-initial`.
- A version is produced by copy only. A file under `versions/` is never edited.
- A file under `versions/` does not make an artifact issue.
- The artifact master controls one phase at a time and waits for user approval before each planned build.
- Each provider component owns one machine-readable contract for its wire surface.
- A provider change passes contract lint, runtime verification, and breaking-change comparison before consumers accept it.
- A consumer team finds the current contract of each provider that it uses.

## Inbound messages

| Message | Kind | From |
| --- | --- | --- |
| Compose repository blueprint | command | Repository maintainer |
| Synchronize accepted artifacts | command | GitHub Actions, Azure Pipelines |
| Publish provider contract | command | Provider team |
| Run contract gates | command | Provider team |
| Compare provider contract | command | Consumer team |

## Outbound messages

| Message | Kind | To |
| --- | --- | --- |
| Repository blueprint composed | event | Repository maintainer |
| Artifact issue synchronized | event | Repository maintainer |
| Acceptance notification sent | event | Repository maintainer |
| Deployment notification sent | event | Repository maintainer |
| Provider contract published | event | Consumer team |
| Breaking change detected | event | Consumer team |
| Contract gate failed | event | Provider team |

## Aggregates

- [Repository blueprint](agg-repository-blueprint.md)

## Assumptions

- A repository maintainer prepares the external project board before synchronization.

## Open questions

- None.
