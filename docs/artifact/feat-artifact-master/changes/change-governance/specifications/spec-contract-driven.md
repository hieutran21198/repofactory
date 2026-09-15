# spec-contract-driven: Write and review one specification

**Master:** [Specifications](README.md)
**Covers:** req-contract-driven-spec
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The solution expert must write the contract before explanatory content. The contract must give
the interface, the events, and the data model. It must also identify the context, the aggregate
when applicable, the invariant, and the upstream-to-downstream relation.

The solution expert must consult the applicable implementation expert when the specification
touches code, an implementation pattern, or the context map. The implementation expert must
return feasibility constraints only. It must not author the specification or the final decision.

The solution expert must resolve each constraint. It must keep the master specification, resolve
conflicts, and use one name for each item. It must write the final decision.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Contract written | Solution expert | Implementation expert | Specification path, interface, events, data model, context, aggregate, invariant, and relation. |
| Constraint returned | Implementation expert | Solution expert | Constraint identifier, statement, evidence, responsible owner, and affected contract item. |

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
| Constraints | Each resolved constraint and its responsible owner. |

No specification is final while one constraint has no resolution or responsible owner.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated solution-expert role keeps specification ownership and records resolved feasibility constraints. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The expert route is solution expert to implementation expert and back. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| The solution-expert role is one canonical text asset with optional DDD chapters. | `services/factory` implementation owner |
| No built-in implementation expert covers `services/factory` in the current role set. | Solution expert |
| A project-specific implementation owner must validate the repository-evidence assumptions before implementation ends. | `services/factory` implementation owner |
| A change artifact is a full replacement file, not a difference. | Solution expert |
| The context map has one context and no upstream-to-downstream context relationship. | Solution expert |
| The Repository blueprint keeps the Domain model pattern selected by `adr-repository-blueprint-pattern`. | Solution expert |

`adr-contract-first` records the evidence, ownership, and selected feasibility sequence.

## Errors

- If a requirement is not clear, the solution expert must stop and ask the requirement owner.
- If no implementation expert covers a component, the solution expert must help select an owner.
- If one constraint is not resolved, the solution expert must not finalize the specification.
- If two specifications conflict, the solution expert must resolve the conflict in the master specification and the final decision.
