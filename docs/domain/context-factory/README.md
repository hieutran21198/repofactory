# context-factory: Repository factory

**Subdomain:** Repository factory
**Type:** Core
**Component:** services/factory

## Purpose

This context combines repository options into a repository blueprint. It decides which files and
working rules the factory supplies to a generated repository. It also holds the rule that each
provider component owns a machine-readable contract for its wire surface. When the maintainer
selects UX Design, it also adds a designer expert and a Design artifact to the Specs and ADRs
phase.

## Ubiquitous language

| Term | Meaning |
| --- | --- |
| Accepted artifact | A feature artifact on the default branch after a pull request merges. |
| Artifact master | The coordinator that controls one artifact-driven change and routes each phase to its owner. |
| Acceptance notification | One team message that summarizes accepted artifact changes from a merged pull request. |
| Artifact issue | A project issue that represents one accepted feature artifact file. |
| Azure Pipelines | An Azure DevOps CI provider that runs factory workflows. |
| Azure Pipelines folder | The folder in a generated repository that holds Azure Pipelines pipeline files. |
| Repository blueprint | The selected options and generated files for one repository. |
| Provider | An external system that receives artifact issues. |
| Harness | A coding agent product that reads the rendered role files and the skills of a project. |
| Implementation expert | A role that owns phase 4 for one component. In phases 2 and 3, it returns feasibility constraints only. |
| Role | An agent persona with one body and one declaration, rendered as one role file for each harness in use. |
| Skill | A folder of instructions that a harness loads on request, copied to each harness in use. |
| Mixture of experts | The harness roles that artifact-driven uses: the artifact master for coordination plus the requirement, solution, and implementation experts for phase content, with routing between them. |
| Documentation site | A website that renders the `docs/` tree of a generated repository and that the selected publication target serves. |
| Publication target | The hosting service that serves the documentation site, `github-pages` or `azure-static-web-app`. One site uses one target. |
| Azure Static Web App | An Azure hosting service that serves static websites. It is one publication target of the documentation site. |
| Deploy tool | The mechanism that uploads the documentation site build output to Azure Static Web Apps, `official-task` or `swa-cli`. |
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
| UX Design | Optional user experience design for a feature: the UX flow, the layout, the interaction, and the component design. |
| Designer expert | A role that owns the Design artifact in the Specs and ADRs phase when UX Design is on. |
| Design artifact | The UX, Layout, Interaction, Components, and Design System output of the designer expert for one feature. |
| Design tool | An optional external tool that the designer expert uses to inspect and change designs. It is an implementation detail. |
| Design constraint | A current Spec or ADR that the Design artifact must follow. |
| Design token | A named design-system value that controls a visual property. |

## Business rules

- The repository is the source of truth for artifacts.
- A rejected artifact proposal does not make a project issue.
- An accepted artifact sync runs on the selected CI provider (github-actions or azure-pipelines) with the same result.
- The Azure Pipelines folder is `azure-pipelines` unless the maintainer selects a different folder.
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
- The artifact master owns all spawning and coordination of experts. The solution expert calls no subagent.
- When no implementation expert covers a component, the artifact master selects its owner with advice from the solution expert.
- Each provider component owns one machine-readable contract for its wire surface.
- A provider change passes contract lint, runtime verification, and breaking-change comparison before consumers accept it.
- A consumer team finds the current contract of each provider that it uses.
- UX Design stays off unless the maintainer selects `artifact-driven.ux-design.enable`.
- When UX Design is off, the artifact-driven workflow stays unchanged.
- UX Design belongs to the Specs and ADRs phase. It adds no separate phase.
- The designer expert uses the accepted Requirements as the baseline and the current Specs and ADRs as constraints.
- The designer expert reuses existing components and tokens when reuse fits and defines new ones only when reuse does not fit.
- The Design artifact does not own business behavior, domain rules, permissions, or constraints.
- The designer expert is a content role. The artifact master owns its coordination.
- A design tool can help the designer expert, but it never gates the Design artifact.
- The UX Design option declaration renders no file.
- When UX Design is off, each generated file stays byte-identical.
- When UX Design is on, the composition emits only conditional roles, chapters, settings, and templates.
- The design-tool domain declares `use`. The artifact-driven composition owns each harness MCP setting.

## Inbound messages

| Message | Kind | From |
| --- | --- | --- |
| Compose repository blueprint | command | Repository maintainer |
| Synchronize accepted artifacts | command | GitHub Actions, Azure Pipelines |
| Publish provider contract | command | Provider team |
| Run contract gates | command | Provider team |
| Compare provider contract | command | Consumer team |
| Contract written | event | Solution expert |
| Constraint returned | event | Implementation expert |
| Work sequenced | event | Solution expert |
| Choice approved | event | User |
| Requirements accepted | event | Requirement expert |
| Specifications and decisions written | event | Solution expert |
| Design completed | event | Designer expert |

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
| Release routed | event | Artifact release expert |
| Feasibility routed | event | Implementation expert |
| Constraint returned | event | Solution expert |
| Option recommended | event | User |
| Work batched | event | Implementation expert |
| UX Design enabled | event | Repository maintainer, artifact master |
| Start Design work | command | Designer expert |
| Reconcile Design | command | Designer expert |

## Aggregates

- [Repository blueprint](agg-repository-blueprint.md)

## Assumptions

- A repository maintainer prepares the external project board before synchronization.

## Open questions

- None.
