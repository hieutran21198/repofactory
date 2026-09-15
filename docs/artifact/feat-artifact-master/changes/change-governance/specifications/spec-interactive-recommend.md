# spec-interactive-recommend: Interview the user about a better path

**Master:** [Specifications](README.md)
**Covers:** req-interactive-recommend
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The requirement expert in phase 1 and the solution expert in phase 2 must draft a plan only. If
the expert finds a correction or a better path, it must stop before the final write. It must send
an option interview to the user.

The interview must contain two or more options. Each option must contain its advantages and its
disadvantages. The interview must contain one recommendation and its reason. The user must select
one option. The expert must finalize the plan from that choice.

If only one feasible path exists, the expert must present that path directly. The artifact master
must not permit the final write before the user gives the mid-build approval.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Option recommended | Requirement expert or solution expert | User | Phase, issue, options, advantages, disadvantages, recommendation, and reason. |
| Choice approved | User | Artifact master and phase expert | Selected option and approval. |

### Data model

The option interview has this data model:

| Field | Type | Rule |
| --- | --- | --- |
| `phase` | `1` or `2` | It identifies the active phase. |
| `issue` | Text | It identifies the correction or better path. |
| `options` | List | It contains at least two options when more than one path is feasible. |
| `advantages` | List for each option | It contains at least one item. |
| `disadvantages` | List for each option | It contains at least one item. |
| `recommendation` | One option identifier | It selects one listed option. |
| `reason` | Text | It explains the recommendation. |
| `user-choice` | One option identifier | It is absent until the user selects an option. |
| `approval` | Boolean | It must be `true` before the final write. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | A generated phase 1 or phase 2 role does not make a final write before the required choice and approval. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The actor route is expert to user and user to artifact master. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| The requirement-expert and solution-expert role assets must contain the same option interview fields. | `services/factory` implementation owner |
| The artifact-master role must enforce the mid-build approval gate. | `services/factory` implementation owner |
| The current artifact-master message contract already has a user choices field and an approval request. | `services/factory` implementation owner |
| The interview stays in chat and does not create a repository status or chat record. | Requirement expert and solution expert |

These constraints use the current role assets and the no-chat-record requirement as evidence.

## Errors

- If an option has no advantages or disadvantages, the expert must correct the interview.
- If the recommendation does not identify one listed option, the expert must correct it.
- If the user has not approved a choice, the artifact master must block the final write.
