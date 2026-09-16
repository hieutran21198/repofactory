# spec-phase-messages: Give phase messages

**Master:** [Specifications](README.md)
**Covers:** req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The canonical role must give short messages that let the user direct and check one phase. The
message format applies in every harness.

The Plan-Pn message must include these fields:

| Field | Required content |
| --- | --- |
| Phase | The phase number and name. |
| Purpose | The result that the phase produces. |
| Input | The committed artifact input, or the business need for phase 1. |
| Scope | The work that Build-Pn can do. |
| Expected files | The files or file folders that Build-Pn can write. |
| Owner | The expert that owns the phase content. |
| Acceptance checks | The checks for the approved result. |
| User choices or actions | Each choice or action, its effect or reason, and the expert that needs the answer. |
| Approval request | A request for explicit approval of Build-Pn. |

Mark an unknown required field as an open item. Do not start Build-Pn without approval.

If a phase 1 or phase 2 expert finds a correction or better path, it must send an option
interview. The message must give at least two options, their advantages and disadvantages, and
one recommendation. If only one path is feasible, the message must present that path directly.

The Phase 4 start message must include Phase, Purpose, approved phase 3 input, Expected output,
Owners, and User actions. It must identify the ordered work batches. It must not request a second
phase approval. It must state that phase 3 approval is the Phase 4 gate.

A progress message must state one completed result, one problem and its effect, one changed
assumption and its effect, or one needed user action. Do not send a routine progress message when
there is no new material information. Give a progress message before the handoff when more than
one material result occurs.

The Build-Pn handoff must include these fields:

| Field | Required content |
| --- | --- |
| Written files | The written or changed files. |
| Checks | The checks and their result. |
| Commit | The phase commit identifier and message. |
| Key decisions | The decisions that affect later work, or `None`. |
| Open items | The unresolved items, or `None`. |
| Next input | The exact committed output that the next phase uses. |
| Next user action | The action that starts the next approved build. |

The phase 4 handoff must report all parallel and sequential task results under one commit. The
handoff is the final message of the phase build. Each message must contain only useful phase
information. It must not repeat unchanged information unless the current user action needs it.

### Events

| Event | Message effect |
| --- | --- |
| Option recommended | Send the option interview to the user. |
| Choice approved | Permit the phase expert to finalize the approved plan. |
| Release routed | Name the artifact release expert as the phase 5 owner. |
| Work sequenced | Show the approved phase 4 work batches. |

### Data model

Each message is a Markdown field list or table. A field name must occur once in its message. The
option interview data model is in `spec-interactive-recommend`. The phase 4 scheduling data model
is in `spec-parallel-implementation`.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact master gives the user the fields needed to direct and check the active phase. |
| Upstream to downstream | None. `context-factory` is the only bounded context. Messages go between the generated roles and the user. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| One canonical artifact-master role body supplies the message format to all harnesses. | `services/factory` implementation owner |
| The option interview must not become a repository chat record. | Requirement expert and solution expert |
| The phase 4 start message must use approved phase 3 dependency data. | Artifact master |
| The phase 5 owner field must name the artifact release expert. | Artifact master |

The current role and wiki assets provide the evidence for these constraints.

## Errors

- If an open item prevents safe work, stop and request the user action.
- If a message omits a required field, add the field or mark it as an open item.
- If a progress message has no material information, do not send it.
- If the required mid-build approval is absent, do not permit the final phase 1 or phase 2 write.
