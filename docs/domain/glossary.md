# Glossary

One term has one meaning in one context. If two contexts use the same word with two meanings,
write two rows.

| Term | Context | Meaning | Not the same as |
| --- | --- | --- | --- |
| Accepted artifact | context-factory | A feature artifact that exists on the default branch after a pull request merges. | Artifact proposal |
| Acceptance notification | context-factory | One team message that summarizes accepted artifact changes from a merged pull request. | Artifact issue |
| Artifact issue | context-factory | A project issue that represents one accepted feature artifact file. | Pull request |
| Artifact proposal | context-factory | An artifact change in a pull request that has not merged. | Accepted artifact |
| Repository blueprint | context-factory | The selected options and generated files for one repository. | Generated repository |
| Provider | context-factory | An external system that receives artifact issues. | CI provider |
| Harness | context-factory | A coding agent product that reads the rendered role files and the skills of a project. Examples: claude, codex, opencode. | Coding agent |
| Implementation expert | context-factory | A role that owns phase 4 of the artifact-driven documentation model for one component, and that gives the solution expert the specifications and the tasks of that component. | Solution expert |
| Role | context-factory | An agent persona with one body and one declaration, rendered as one role file for each harness in use. | Skill |
| Skill | context-factory | A folder of instructions that a harness loads on request, copied to the skill folder of each harness in use. | Role |
| Documentation site | context-factory | A website that renders the `docs/` tree of a generated repository and that GitHub Pages serves. | Wiki |
| Deployment notification | context-factory | One team message that reports a successful documentation site deployment. | Acceptance notification |
