# Glossary

One term has one meaning in one context. If two contexts use the same word with two meanings,
write two rows.

| Term | Context | Meaning | Not the same as |
| --- | --- | --- | --- |
| Accepted artifact | context-factory | A feature artifact that exists on the default branch after a pull request merges. | Artifact proposal |
| Acceptance notification | context-factory | One team message that summarizes accepted artifact changes from a merged pull request. | Artifact issue |
| Artifact issue | context-factory | A project issue that represents one accepted feature artifact file. | Pull request |
| Artifact proposal | context-factory | An artifact change in a pull request that has not merged. | Accepted artifact |
| Artifact master | context-factory | The coordinator that controls one artifact-driven change and routes each phase to its owner. | Phase owner |
| Artifact release expert | context-factory | A role that owns phase 5 of the artifact-driven documentation model and that copies the version without edits. | Solution expert |
| Azure Pipelines | context-factory | An Azure DevOps CI provider that runs factory workflows. | GitHub Actions |
| Azure Pipelines folder | context-factory | The folder in a generated repository that holds Azure Pipelines pipeline files. The default folder is `azure-pipelines`. | Pipeline file |
| Repository blueprint | context-factory | The selected options and generated files for one repository. | Generated repository |
| Provider | context-factory | An external system that receives artifact issues. | CI provider |
| Harness | context-factory | A coding agent product that reads the rendered role files and the skills of a project. Examples: claude, codex, opencode. | Coding agent |
| Implementation expert | context-factory | A role that owns phase 4 for one component. In phases 2 and 3, it returns feasibility constraints only through the artifact master. It does not author specifications, decisions, or tasks. | Solution expert |
| Role | context-factory | An agent persona with one body and one declaration, rendered as one role file for each harness in use. | Skill |
| Skill | context-factory | A folder of instructions that a harness loads on request, copied to the skill folder of each harness in use. | Role |
| Mixture of experts | context-factory | The harness roles that artifact-driven uses: the artifact master for coordination plus the requirement, solution, and implementation experts for phase content, with routing between them. | Harness |
| Documentation site | context-factory | A website that renders the `docs/` tree of a generated repository and that the selected publication target serves. | Wiki |
| Publication target | context-factory | The hosting service that serves the documentation site, `github-pages` or `azure-static-web-app`. One site uses one target. | CI provider |
| Azure Static Web App | context-factory | An Azure hosting service that serves static websites. It is one publication target of the documentation site. | GitHub Pages |
| Deploy tool | context-factory | The mechanism that uploads the documentation site build output to Azure Static Web Apps, `official-task` or `swa-cli`. One site uses one tool. | Publication target |
| Generated documentation asset | context-factory | A file that a workflow makes and adds to a documentation site static directory. | Authored Markdown page |
| Deployment notification | context-factory | One team message that reports a successful documentation site deployment. | Acceptance notification |
| Notification provider | context-factory | An external system that receives a team notification. | Project-management provider |
| Phase handoff | context-factory | A short report of a completed phase build and the input for the next phase. | Phase plan |
| Phase plan | context-factory | A read-only proposal that defines one phase build and waits for user approval. | Implementation plan |
| Change | context-factory | One unit of work on a feature, in `changes/change-<name>/`. It holds the reason and the artifacts that change. | Version |
| Version | context-factory | The full requirements, specifications, and decisions of a feature after one change, in `versions/<version>/`. Named major.minor.patch. | Change |
| Current version | context-factory | The version that the feature README names. It gives the current state of the feature. | Status |
| Change type | context-factory | The kind of a change: Requirements, Specifications, Decisions, or Correction. It gives the part of the version number that the change bumps. | Artifact type |
| Provider contract | context-factory | A machine-readable description of the wire surface of one polyrepo component, owned by the provider team. | Wire format |
| Consumer team | context-factory | A team that uses the wire surface of a provider component. | Provider team |
| Breaking change | context-factory | A contract change that forces a consumer team to change its code. | Compatible change |
| Work batch | context-factory | One ordered group of phase 4 tasks that the artifact master makes from the recorded dependencies. | Task |
| UX Design | context-factory | Optional user experience design for a feature: the UX flow, the layout, the interaction, and the component design. | Design system |
| Designer expert | context-factory | A role that owns the Design artifact in the Specs and ADRs phase when UX Design is on. | Solution expert |
| Design artifact | context-factory | The UX, Layout, Interaction, Components, and Design System output of the designer expert for one feature. | Specification |
| Design tool | context-factory | An optional external tool that the designer expert uses to inspect and change designs. It is an implementation detail. | Skill |
