# spec-parallel-implementation: Run permitted tasks in parallel

**Master:** [Specifications](README.md)
**Covers:** req-parallel-implementation
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

Phase 3 must record the dependencies and one `can-parallel` answer for each task. The answer must
be `yes` or `no`. Phase 4 must use these records to make ordered work batches.

Tasks in different components or contexts with no dependency must run in parallel. Tasks in the
same aggregate or context must run in sequence. A downstream task must run after the upstream
task that supplies its input. Shared kernel or published language work in `libs/` must run before
its consumers. One commit must contain all phase 4 output.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Work sequenced | Solution expert | Artifact master and implementation experts | Ordered batches, task dependencies, component or context, aggregate, and each `can-parallel` answer. |

### Data model

Each phase 3 task must contain this scheduling data:

| Field | Type | Rule |
| --- | --- | --- |
| `task` | Task identifier | It identifies one task file. |
| `context` | Context identifier | One task has one bounded context. |
| `component` | Repository path | It identifies the component that the task changes. |
| `aggregate` | Aggregate identifier or `none` | It identifies the changed aggregate. |
| `depends-on` | List of task identifiers or `none` | Each identifier must name another phase 3 task. |
| `can-parallel` | `yes` or `no` | It gives the required yes-or-no answer. |

The phase 4 schedule must be a list of ordered batches. Tasks in one batch can run concurrently.
All dependencies of a batch must complete before that batch starts.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact master obeys phase 3 dependencies and keeps one phase 4 commit. |
| Upstream to downstream | None for this change. `context-factory` is the only bounded context. A future context relation must place upstream work first. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| The solution-expert role must add dependency and `can-parallel` fields to each phase 3 task contract. | `services/factory` implementation owner |
| The artifact-master role must make work batches from approved phase 3 data. | `services/factory` implementation owner |
| Implementation experts are project-specific roles, not built-in factory roles. | Solution expert |
| The current context map has no shared kernel, published language, or downstream context. | Solution expert |
| Parallel work must still end in one phase 4 commit. | Artifact master |

These constraints are assumptions from the role builder, the expert-role skill, and the context
map. The `services/factory` implementation owner must verify them during implementation.

## Errors

- If a task has no `can-parallel` answer, phase 4 must not start that task.
- If a dependency names no task, phase 4 must stop and return the plan error.
- If tasks share a context or aggregate, the artifact master must not run them in parallel.
- If an upstream result is absent, the downstream task must not start.
