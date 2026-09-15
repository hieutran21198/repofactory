# spec-verification-contract: Verify the coordination contract

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The artifact-driven composition evaluation must test the source text and the rendered output. It
must prove that each selected harness receives the required coordination and communication rules.

The evaluation must check that the canonical artifact-master role contains:

- the five-phase order, the prior committed input rule, the approval gate, and one phase commit;
- the routes for phases 1, 2, 3, 4, and 5, including the uncovered component route;
- the artifact release expert route and the solution expert version gate;
- the coordination-only boundary and the phase content that the coordinator cannot write;
- every Plan-Pn field and every handoff field from `spec-phase-messages`;
- the material-progress rule and the no-routine-message rule;
- the Phase 4 start fields, the absence of Plan-P4, and phase 3 approval as its gate;
- the phase 4 dependency and `can-parallel` rules; and
- the concise-message rule.

The evaluation must check that the requirement-expert and solution-expert roles contain the
option interview. It must check that the solution-expert role contains the contract-first and
feasibility rules.

The evaluation must check that the artifact-release-expert role contains the copy-only, delete,
no-edit, no-DDD, low-cost, and verification rules. It must check that each selected harness
renders all built-in roles.

The evaluation must check that the artifact-master skill identifies the role path for OpenCode,
Claude, and Codex. The skill must not copy the role body. It must use the new phase 5 route.

The evaluation must check the canonical mixture-of-experts page and its mirrors. Each page must
contain the current phase 5 owner and the four governance rules.

### Events

| Event contract | Required check |
| --- | --- |
| Release routed | The artifact master names the artifact release expert and requires readiness confirmation. |
| Contract written | The solution expert sends a contract with interface, events, and data model for feasibility review. |
| Constraint returned | The implementation expert returns constraints without authoring the specification. |
| Option recommended | The interview has options, advantages, disadvantages, and one recommendation. |
| Choice approved | The mid-build gate blocks the final write until approval exists. |
| Work sequenced | The phase 4 schedule follows dependencies and each `can-parallel` answer. |

### Data model

Each evaluation result must be a Boolean assertion. The complete evaluation must fail when one
required assertion is false. Text assertions are permitted for role, skill, and Markdown
contracts. Rendered-role assertions must cover OpenCode, Claude, and Codex.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | A Repository blueprint is not valid when one selected harness lacks a required governance contract. |
| Upstream to downstream | None. `context-factory` is the only bounded context. Verification checks generated outputs inside the context. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| The current evaluation uses Nix Boolean assertions and text matching for instruction contracts. | `services/factory` implementation owner |
| The role list and expert role list must include the artifact release expert in applicable checks. | `services/factory` implementation owner |
| Canonical and rendered role checks must change together. | `services/factory` implementation owner |
| The canonical wiki page and two mirrors must remain equal. | `services/factory` implementation owner |
| No code or evaluation ran during phase 2. | `services/factory` implementation owner |

The implementation owner must verify these repository-evidence assumptions during phase 4.

## Errors

- A missing required role section fails the evaluation.
- A missing harness role or skill path fails the evaluation.
- A forbidden phase-content instruction for the artifact master fails the evaluation.
- An old phase 5 route fails the evaluation.
- A missing constraint owner or `can-parallel` rule fails the evaluation.
- A wiki mirror that differs from the canonical page fails the evaluation.
