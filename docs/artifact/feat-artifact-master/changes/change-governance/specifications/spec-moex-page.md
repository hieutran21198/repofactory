# spec-moex-page: Explain the mixture of experts

**Master:** [Specifications](README.md)
**Covers:** req-moex-explanation
**Context:** context-factory

## Contract

### Interface

The canonical page is `docs/wiki/documentation/mixture-of-experts/README.md`. It must explain how
artifact-driven work uses one coordinator and multiple content experts. A reader must be able to
use the page without prior harness role knowledge.

The page must be an English Markdown file. It must not use a generated include, a transclusion,
or an external source for its required content.

The page must contain these sections:

| Section | Required content |
| --- | --- |
| Mixture of experts | Define the artifact master and each content expert. |
| Roles and ownership | Contrast coordination ownership with phase-content ownership. |
| Phase routing | Map phases 1 to 5 to their content owners and identify the version gate. |
| Plan-Pn then Build-Pn | Explain the read-only plan, approval, build, commit boundary, and prior committed input. |
| Two kinds of plan | Contrast the chat-only `coordinate-plan` with the phase 3 execution plan. |
| Contract-driven specifications | Explain contract-first authorship, feasibility review, constraints, and final ownership. |
| Option interview | Explain options, advantages, disadvantages, one recommendation, and approval. |
| Parallel implementation | Explain dependencies, `can-parallel`, ordered batches, and one commit. |
| Harness rendering | Explain how canonical role bodies become rendered roles for selected harnesses. |
| Skill load | Explain how the artifact-master skill loads the rendered artifact-master role. |
| Related documentation | Link to `../artifact-driven/README.md` for the detailed rules. |

The page must define these terms at first use:

| Term | Definition |
| --- | --- |
| Artifact master | The role that coordinates one artifact-driven change and routes each phase. |
| Content expert | A role that owns the content of one or more phases. |
| Artifact release expert | The role that owns the mechanical phase 5 copy. |
| Contract | A testable interface, event, or data model in a specification. |
| Constraint | A feasibility limit with one responsible owner. |
| `can-parallel` | The yes-or-no phase 3 answer that permits or prevents parallel task work. |
| Harness | A coding agent product that reads the role files and skills of a project. |
| Role | An agent persona with one instruction body and one harness declaration. |
| Skill | A folder of instructions that a harness loads on request. |
| Canonical role body | The shared source of one role contract. |
| Rendered role | A canonical role body in the file format of one harness. |

The roles and ownership section must identify these boundaries:

| Role | Content ownership |
| --- | --- |
| Artifact master | Coordination only. It writes no phase content. |
| Requirement expert | Requirements in phase 1. |
| Solution expert | Specifications and decisions in phase 2, tasks in phase 3, and the version gate. |
| Implementation expert | Feasibility constraints in phase 2, and code and tests for one component in phase 4. |
| Artifact release expert | The copy-only version output in phase 5. |

The phase routing section must contain this route:

| Phase | Content owner |
| --- | --- |
| P1 Requirements | Requirement expert |
| P2 Specifications | Solution expert |
| P3 Plan | Solution expert |
| P4 Implementation | Implementation expert for each component |
| P5 Version | Artifact release expert |

The page must state that the solution expert confirms release readiness only. It must state that
the solution expert does not copy the version.

The harness rendering section must identify OpenCode, Claude, and Codex. It must explain that
each selected harness receives the same body for each built-in role. Harness declaration data can
differ. This explanation must agree with `spec-harness-delivery`.

The rendered artifact-master paths are:

| Harness | Rendered role | Role selection |
| --- | --- | --- |
| OpenCode | `.opencode/agents/artifact-master.md` | Selectable coordinator role. |
| Claude | `.claude/agents/artifact-master.md` | Delegated role. |
| Codex | `.codex/agents/artifact-master.toml` | Delegated role. |

The artifact release expert must be a delegated content expert in each selected harness. The
skill-load section must state that the artifact-master skill does not repeat the role body.

The page must use a table or diagram for each route with more than two endpoints. It must not
copy the full five-phase procedure or detailed harness delivery contract. The related link must
give access to those details.

### Events

The page must name these governance events: Release routed, Contract written, Constraint
returned, Option recommended, Choice approved, and Work sequenced.

### Data model

The page is a self-contained Markdown document. Its required section, term, role, route, harness,
and event tables are its testable data model.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | None. This specification changes page content, not aggregate state. |
| Invariant | The page must agree with the current role ownership and routing contracts. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The page explains actor routes. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| One canonical page supplies the required content. | `services/factory` implementation owner |
| The single and multiple repository layouts each have one page mirror. | `services/factory` implementation owner |
| DDD variants use the mirror for their repository layout. | `services/factory` implementation owner |
| The DDD artifact-driven page mirrors must also change their phase 5 owner row. | `services/factory` implementation owner |
| The page must stay self-contained and equal to both layout mirrors. | `services/factory` implementation owner |

These constraints are assumptions from the canonical page, the Nix file map, and its evaluation.

## Errors

- A missing canonical page fails the artifact-driven composition evaluation.
- A missing required section, term, role, phase, harness, or event fails the evaluation.
- Required content from an include, transclusion, or external source fails the evaluation.
- Content that conflicts with a current governance contract fails the evaluation.
- A page mirror that differs from the canonical page fails the evaluation.
