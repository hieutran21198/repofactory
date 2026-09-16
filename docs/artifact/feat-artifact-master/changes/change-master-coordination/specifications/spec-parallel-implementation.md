# spec-parallel-implementation: Run permitted tasks in parallel

**Master:** [Specifications](README.md)
**Covers:** req-parallel-implementation, req-expert-routing
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

Phase 3 must record the dependencies and one `can-parallel` answer for each task. The answer must
be `yes` or `no`. The solution expert must give the approved execution plan to the artifact
master. It must not start an implementation expert.

The artifact master must validate the task records. It must make ordered work batches from the
dependencies and each `can-parallel` answer. It must select and spawn each implementation expert.

The batching rules are:

1. Run shared kernel or published language work before its consumers.
2. Run an upstream task before each downstream task that consumes its result.
3. Run tasks in the same component, context, or aggregate in sequence.
4. Run a task with `can-parallel: no` in a batch by itself.
5. Run independent ready tasks with `can-parallel: yes` in the same batch.
6. Complete one batch before the artifact master starts a dependent batch.
7. Join all task results before the one phase 4 commit.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Work sequenced | Solution expert | Artifact master | Approved tasks, dependencies, context, component, aggregate, and `can-parallel` answers. |
| Owner selected | Artifact master | Implementation expert | Task, component, selected owner, and selection reason. |
| Work batched | Artifact master | Implementation experts | Batch identifier, ordered position, task identifiers, owners, and completed prerequisites. |

### Data model

Each phase 3 task must contain this scheduling data:

| Field | Type | Rule |
| --- | --- | --- |
| `task` | Task identifier | It identifies one task file. |
| `context` | Context identifier | One task has one bounded context. |
| `component` | Repository path | It identifies the component that the task changes. |
| `aggregate` | Aggregate identifier or `none` | It identifies the changed aggregate. |
| `depends-on` | Task identifiers or `none` | Each identifier names another phase 3 task. |
| `can-parallel` | `yes` or `no` | It permits or prevents concurrent work. |
| `parallel-reason` | Text | It gives the reason for the answer. |

Each work batch must contain its identifier, ordered position, tasks, owners, prerequisites, and
commit boundary. Tasks in one batch can run concurrently.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact master alone starts phase 4 experts and obeys the approved task dependencies. |
| Upstream to downstream | None for this change. A future relation must place upstream work before downstream work. |

## Description

The solution expert specifies the work order in phase 3. The artifact master converts that order
to executable batches in phase 4. Content ownership stays with each implementation expert.

## Constraint resolutions

[`adr-master-coordination`](../decisions/adr-master-coordination.md) records the phase 4 ownership
and batching resolutions. [`adr-opencode-coordination-permissions`](../decisions/adr-opencode-coordination-permissions.md)
records the OpenCode depth and spawn constraints.

## Errors

- If a task has no `can-parallel` answer or reason, do not start that task.
- If a dependency names no task or forms a cycle, stop phase 4 and return the plan error.
- If two tasks share a component, context, or aggregate, do not put them in the same batch.
- If an upstream result is absent, do not start its downstream task.
- If one task has no owner, do not start its batch.
