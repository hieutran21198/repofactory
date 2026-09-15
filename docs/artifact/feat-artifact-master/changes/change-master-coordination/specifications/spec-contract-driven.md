# spec-contract-driven: Write and review one specification

**Master:** [Specifications](README.md)
**Covers:** req-contract-driven-spec, req-expert-routing
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The solution expert must write the contract before explanatory content. The contract must give
the interface, the events, and the data model. It must identify the context, the aggregate when
applicable, the invariant, and the upstream-to-downstream relation.

When a specification touches code, a pattern, or the context map, the solution expert must send a
feasibility-review request to the artifact master. It must not spawn or directly task an
implementation expert.

The artifact master must route the unchanged contract to the applicable implementation expert.
The implementation expert must return feasibility constraints only. It must not author a
specification, a decision, or a task. The artifact master must return the constraints without a
change to their technical content.

The solution expert must resolve each constraint. It must keep the master specification and use
one name for each item. It must write the final decision. A specification is not final while a
constraint has no resolution or responsible owner.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Contract written | Solution expert | Artifact master | Review identifier, specification path, contract, context, aggregate, invariant, and relation. |
| Feasibility routed | Artifact master | Implementation expert | The unchanged Contract written payload and the target component. |
| Constraint returned | Implementation expert | Artifact master, then solution expert | Constraint identifier, statement, evidence, responsible owner, and affected contract item. |

### Data model

Each changed `spec-<name>.md` must contain this data:

| Data | Required value |
| --- | --- |
| `Master` | A link to `specifications/README.md`. |
| `Covers` | One or more requirement identifiers. |
| `Context` | One bounded context. |
| `Aggregate` | The changed aggregate, when the specification changes one. |
| Interface | The input, output, operation, or file contract. |
| Events | Each produced or consumed event, or an explicit `None`. |
| Data model | The fields, types, and rules, or an explicit `None`. |
| Invariant | The rule that the contract keeps true. |
| Relation | The upstream-to-downstream context relation, or an explicit `None`. |
| Constraints | Each constraint, its resolution, and its responsible owner. |

The feasibility-review request must contain a review identifier, the specification path, the
component, and the complete contract. A returned constraint must keep the same review identifier.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated solution expert owns specification content and calls no subagent. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The artifact master routes the internal expert exchange. |

## Description

The artifact master owns the transport of each feasibility review. The solution expert owns the
contract and its final resolution. The implementation expert owns only the technical constraints
that it returns.

## Constraint resolutions

[`adr-contract-first`](../decisions/adr-contract-first.md) records the feasibility route, the
content boundary, and the permitted text assertions.

## Errors

- If a requirement is not clear, stop and ask the requirement owner.
- If no implementation expert covers a component, ask the artifact master to select an owner.
- If the review identifier changes during routing, reject the returned constraint.
- If one constraint has no resolution or owner, do not finalize the specification.
- If two specifications conflict, resolve the conflict in the master specification and final decision.
