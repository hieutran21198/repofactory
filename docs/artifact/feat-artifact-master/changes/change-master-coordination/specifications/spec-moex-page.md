# spec-moex-page: Explain the mixture of experts

**Master:** [Specifications](README.md)
**Covers:** req-moex-explanation
**Context:** context-factory

## Contract

### Interface

The canonical page is `docs/wiki/documentation/mixture-of-experts/README.md`. It must be a
self-contained English Markdown page. It must explain one coordinator and multiple content
experts without prior harness knowledge.

The page must contain these sections:

| Section | Required content |
| --- | --- |
| Mixture of experts | Define the artifact master, the harness, each content expert, a role, and a skill. |
| Roles and ownership | State that the artifact master owns coordination only and owns all spawning. |
| Phase routing | Map phases 1 to 5 to their content owners and identify the version gate. |
| Plan-Pn then Build-Pn | Explain the read-only plan, approval, build, prior commit, and phase commit. |
| Two kinds of plan | Contrast the chat-only `coordinate-plan` with the phase 3 `execution-plan`. |
| Contract-driven specifications | Explain contract-first authorship and master-routed feasibility review. |
| Owner selection | Explain solution-expert advice and artifact-master selection for an uncovered component. |
| Option interview | Explain the options, recommendation, and approval gate. |
| Parallel implementation | Explain dependencies, `can-parallel`, artifact-master batching, spawning, and one commit. |
| Harness rendering | Explain one instruction body, harness declarations, and OpenCode primary-agent selection. |
| Skill load | Tell the OpenCode user to select the artifact master as the primary agent. |
| Governance events | Name and route the required events. |
| Related documentation | Link to `../artifact-driven/README.md`. |

The page must state these rules directly:

- The artifact master owns all spawning and coordination of experts.
- The artifact master never owns phase content.
- The solution expert calls no subagent and does not directly task another expert.
- The artifact master routes each phase 2 feasibility review.
- An implementation expert returns constraints only. It does not author specifications or tasks.
- The artifact master selects the owner of an uncovered component with solution-expert advice.
- The artifact master makes and starts phase 4 work batches from the approved task data.
- For factory-rendered OpenCode roles, the settings declare task permission for each role.
- The settings declare `allow` for the artifact master and `deny` for each content expert.
- The OpenCode subagent depth is 1.
- The OpenCode user must select the artifact master as the primary agent.

The page must identify OpenCode, Claude, and Codex. It must state that each selected harness
receives the same instruction body for each built-in role. Harness frontmatter can differ.

### Events

| Event | Required route |
| --- | --- |
| Coordination moved | Artifact master to content experts. |
| Contract written | Solution expert to artifact master. |
| Feasibility routed | Artifact master to implementation expert. |
| Constraint returned | Implementation expert to artifact master, then solution expert. |
| Owner selected | Artifact master to the affected experts. |
| Option recommended | Requirement expert or solution expert to user. |
| Choice approved | User to artifact master and phase expert. |
| Work sequenced | Solution expert to artifact master. |
| Work batched | Artifact master to implementation experts. |
| Release routed | Artifact master to artifact release expert. |

### Data model

The page's section, term, role, route, harness, declared-permission, and event tables are its
testable data model. The page must use a table or diagram for each route with more than two
endpoints.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | None. This specification changes page content, not aggregate state. |
| Invariant | The page agrees with the current role ownership, coordination, declared-permission, and routing contracts. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The page explains actor routes. |

## Description

The page is the self-contained explanation that a generated repository supplies to its users. It
does not copy the complete five-phase procedure or the detailed Nix delivery contract.

## Constraint resolutions

[`adr-master-coordination`](../decisions/adr-master-coordination.md) records the canonical-page,
mirror, and coordination-text resolutions. [`adr-opencode-coordination-permissions`](../decisions/adr-opencode-coordination-permissions.md)
records the declared-permission wording.

## Errors

- A missing required section, rule, harness, declared permission, or event fails the evaluation.
- Content that gives spawning to a content expert fails the evaluation.
- Content that bypasses the artifact master for feasibility review fails the evaluation.
- Content that calls an absent permission a deny fails the evaluation.
- Content that conflicts with a current governance contract fails the evaluation.
