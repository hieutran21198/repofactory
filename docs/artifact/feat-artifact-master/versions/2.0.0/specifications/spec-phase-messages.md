# spec-phase-messages: Give phase messages

**Master:** [Specifications](README.md)
**Covers:** req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The canonical role gives short messages that let the user direct and check one phase. The message format applies in every harness.

## Contract

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
| User choices or actions | Each needed choice or action, its effect or reason, and the expert that needs a content answer. |
| Approval request | A request for explicit approval of Build-Pn. |

Mark an unknown required field as an open item. Do not start Build-Pn without approval.

The Phase 4 start message must include Phase, Purpose, approved phase 3 input, Expected output, Owners, and User actions. It does not request a second phase approval. It must state that phase 3 approval is the Phase 4 gate.

A progress message must state one completed result, one problem and its effect, one changed assumption and its effect, or one needed user action. Send no routine progress message when there is no new material information. Give a progress message before the handoff when more than one material result occurs.

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

The handoff is the final message of the phase build. Each message includes only information that helps the user understand, decide, act, or check the current phase. It does not repeat unchanged information unless the current user action needs it.

## Errors

- If an open item prevents safe work, stop and request the user action.
- If a message would omit a required field, add the field or mark it as an open item.
- If a progress message has no material information, do not send it.
