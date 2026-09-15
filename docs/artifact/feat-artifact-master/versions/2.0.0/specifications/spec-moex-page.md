# spec-moex-page: Explain the mixture of experts

**Master:** [Specifications](README.md)
**Covers:** req-moex-explanation
**Context:** context-factory

## Description

The page explains how artifact-driven work uses one coordinator and multiple content experts. A
reader can use the page without prior knowledge of the harness roles.

## Contract

The canonical page is `docs/wiki/documentation/mixture-of-experts/README.md`. The page is an
English Markdown file. It must not use a generated include, a transclusion, or an external source
for its required content.

The page must contain these sections:

| Section | Required content |
| --- | --- |
| Mixture of experts | Define the artifact master as the coordinator and the other roles as content experts. |
| Roles and ownership | Contrast coordination ownership with phase-content ownership. |
| Phase routing | Map phases 1 to 5 to their content owners. |
| Plan-Pn then Build-Pn | Explain the read-only plan, user approval, phase build, commit boundary, and prior committed input. |
| Two kinds of plan | Contrast the chat-only `coordinate-plan` with the phase 3 `execution-plan` in `tasks/`. |
| Harness rendering | Explain how one canonical role body becomes a rendered role for each selected harness. |
| Skill load | Explain how the artifact-master skill loads the rendered role for the harness in use. |
| Related documentation | Link to `../artifact-driven/README.md` for the detailed phase and artifact rules. |

The page must define these terms at first use:

| Term | Definition |
| --- | --- |
| Artifact master | The role that coordinates one artifact-driven change and routes each phase. |
| Content expert | A role that owns the content of one or more phases. |
| Harness | A coding agent product that reads the role files and skills of a project. |
| Role | An agent persona with one instruction body and one harness declaration. |
| Skill | A folder of instructions that a harness loads on request. |
| Canonical role body | The shared source of the artifact-master coordination contract. |
| Rendered role | The canonical role body in the file format of one harness. |

The roles and ownership section must identify these boundaries:

| Role | Content ownership |
| --- | --- |
| Artifact master | Coordination only. It writes no phase content. |
| Requirement expert | Requirements in phase 1. |
| Solution expert | Specifications, decisions, tasks, and versions in phases 2, 3, and 5. |
| Implementation expert | Code and tests for one component in phase 4. |

The phase routing section must contain this route:

| Phase | Content owner |
| --- | --- |
| P1 Requirements | Requirement expert |
| P2 Specifications | Solution expert |
| P3 Plan | Solution expert |
| P4 Implementation | Implementation expert for each component |
| P5 Version | Solution expert |

The harness rendering section must identify OpenCode, Claude, and Codex. It must explain that
each selected harness receives the same role body contract. Harness-specific declaration data can
differ. This explanation must agree with [spec-harness-delivery](spec-harness-delivery.md).

The skill load section must identify the rendered `artifact-master` role as the source of the
coordination contract. It must state that the skill does not repeat the role body.

The page must use a table or a diagram for each route that has more than two endpoints. It must
not copy the full five-phase procedure or the detailed harness delivery contract from existing
artifacts. The related link gives access to those details.

## Errors

- A missing canonical page fails the artifact-driven composition evaluation.
- A missing required section, role row, or phase row fails the evaluation.
- Required content from an include, a transclusion, or an external source fails the evaluation.
- Content that conflicts with the current coordination or harness delivery contract fails the evaluation.
