# Mixture of experts

Artifact-driven documentation uses a mixture of experts. This page explains the roles in that
mixture and the routing between them. The page needs no other document. It uses these terms:

| Term | Meaning |
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
| Rendered role | The canonical role body in the file format of one harness. |

## Roles and ownership

The artifact master owns coordination only. It writes no phase content. A content expert owns
the content of one or more phases. The owner of a phase writes the artifacts of that phase.

| Role | Content ownership |
| --- | --- |
| Artifact master | Coordination only. It writes no phase content. |
| Requirement expert | Requirements in phase 1. |
| Solution expert | Specifications and decisions in phase 2, tasks in phase 3, and the version gate. |
| Implementation expert | Feasibility constraints in phase 2, and code and tests for one component in phase 4. |
| Artifact release expert | The copy-only version output in phase 5. |

## Phase routing

The artifact master routes each phase to its content owner. The table gives the route.

| Phase | Content owner |
| --- | --- |
| P1 Requirements | Requirement expert |
| P2 Specifications | Solution expert |
| P3 Plan | Solution expert |
| P4 Implementation | Implementation expert for each component |
| P5 Version | Artifact release expert |

The solution expert confirms release readiness only. The solution expert does not copy the
version. The artifact release expert copies, replaces, deletes, and verifies the version.

## Plan-Pn then Build-Pn

The artifact master uses `Plan-Pn then Build-Pn`. It does one phase at a time. It does not plan
all five phases in one pass.

- A plan is read-only. The coordinator writes no file and makes no commit during a plan.
- Plan-P1 reads the business need or the change reason.
- Plan-P2, Plan-P3, and Plan-P5 read only the committed output of the prior phase.
- A later phase does not start before the commit of the prior phase exists.
- The coordinator stops after each plan. It waits for explicit user approval before the build.
- Each build writes only the output of its phase. Each build ends with one commit for that phase.
- Phase 4 has no Plan-P4. It starts from the implementation plan that the user approved in phase 3.

## Two kinds of plan

The model uses two plans. They do not have the same owner and they do not live in the same place.

| Plan | Location | Owner | Content |
| --- | --- | --- | --- |
| `coordinate-plan` | Chat only. | Artifact master. | The change name, the `From/To/Type` triple, the expert order, each phase commit boundary, and each phase input and output. |
| `execution-plan` | `tasks/README.md` and `task-<name>.md` in phase 3. | Solution expert. | The order of work and one task for each unit of work. |

The artifact master keeps the `coordinate-plan` in the chat. It does not put the plan in
`tasks/`. Only the solution expert writes the `execution-plan`, after the commit of phase 2.

## Contract-driven specifications

The solution expert writes the contract before the explanatory content. The contract gives the
interface, the events, and the data model. It also gives the context, the aggregate, the
invariant, and the upstream-to-downstream relation when they apply.

The solution expert sends the contract to the implementation expert of each affected component.
The implementation expert returns feasibility constraints only. The implementation expert does
not author the specification and does not write the final decision. The solution expert records
each constraint and its responsible owner in the decision record. The solution expert resolves
each constraint and keeps one name for each item. No specification is final while one constraint
has no resolution or responsible owner.

## Option interview

A phase 1 or phase 2 expert that finds a correction or a better path sends an option interview
to the user before the final write. The interview gives at least two options with their
advantages and their disadvantages. It gives one recommendation and its reason. The user selects
one option. The expert finalizes the plan from that choice. If only one path is feasible, the
expert presents that path directly.

The artifact master gates the build. It does not permit the final write before the mid-build
approval exists. The interview stays in the chat. It is not a repository record.

## Parallel implementation

Phase 3 records the dependency and the `can-parallel` answer for each task. The answer is `yes`
or `no`. The solution expert also gives a reason for the answer.

Phase 4 makes ordered work batches from those records. Tasks in different components or contexts
with no dependency can run in parallel. Tasks in the same component, context, or aggregate run in
sequence. A downstream task runs after the upstream task that supplies its input. Shared kernel
and published language work in `libs/` runs before its consumers. All phase 4 output stays in one
commit.

## Harness rendering

A harness is a coding agent product. The project selects one or more harnesses. Each selected
harness receives the same role body contract from one canonical role body. The factory renders
the canonical role body into the file format of the harness. Harness-specific declaration data
can differ. The role body contract does not change.

The factory renders the artifact-master role for these harnesses:

| Harness | Rendered role | Role selection |
| --- | --- | --- |
| OpenCode | `.opencode/agents/artifact-master.md` | Selectable coordinator role. |
| Claude | `.claude/agents/artifact-master.md` | Delegated role. |
| Codex | `.codex/agents/artifact-master.toml` | Delegated role. |

OpenCode supplies the artifact master as a selectable coordinator role. Claude and Codex supply
it as a delegated role. They also supply the delegating skill. The artifact release expert is a
delegated content expert in each selected harness.

## Skill load

The artifact-master skill loads the rendered role for the harness in use. The rendered
`artifact-master` role is the source of the coordination contract. The skill does not repeat the
role body. The skill gives the path of each rendered role:

- OpenCode: `.opencode/agents/artifact-master.md`.
- Claude: `.claude/agents/artifact-master.md`.
- Codex: `.codex/agents/artifact-master.toml`.

The harness loads the skill on request. The skill then tells the harness to load the rendered
role before the coordination of a change.

## Governance events

The model has these governance events:

| Event | Producer | Consumer |
| --- | --- | --- |
| Release routed | Artifact master | Artifact release expert |
| Contract written | Solution expert | Implementation expert |
| Constraint returned | Implementation expert | Solution expert |
| Option recommended | Requirement expert or solution expert | User |
| Choice approved | User | Artifact master and phase expert |
| Work sequenced | Solution expert | Artifact master and implementation experts |

## Related documentation

Read [Artifact-Driven Documentation](../artifact-driven/README.md) for the five phases, the
artifacts of a change, and the rules of each phase.
