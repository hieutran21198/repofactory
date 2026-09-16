# req-contract-driven-spec: Write the contract first

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The solution expert must write the contract first in phase 2. The
contract must give the interface, the events, and the data model.
Each specification must cover its requirement. Each specification
must name its context, its aggregate, its invariant, and its
upstream-to-downstream context-map relation. The implementation
expert must review feasibility and must return constraints. The
implementation expert must not author the specification. The solution
expert must keep the master specification. The solution expert must
write the final architecture decision record. The solution expert
must resolve conflicts and must keep names consistent.

The artifact master must route each feasibility review between the
solution expert and the implementation expert. The solution expert
must not directly task the implementation expert. It must send each
contract through the artifact master. It must record each constraint
and its responsible owner in the architecture decision record. No
specification is final without its constraints.

## Acceptance criteria

- Given phase 2, when the solution expert writes a specification, then the contract comes first with interface, events, and data model.
- Given a specification, when the user reads it, then the user can identify its requirement, context, aggregate, invariant, and upstream-to-downstream relation.
- Given a specification that touches code, a pattern, or the context map, when the solution expert prepares it, then the artifact master routes it to the implementation expert and the decision record shows each constraint with its owner.
- Given the solution expert, when it needs a feasibility review, then it does not directly task the implementation expert.
- Given open constraints, when the solution expert reviews the specification, then the specification is not final.
- Given a conflict or a name clash, when the solution expert ends phase 2, then the master specification and the final decision record resolve it.

## Notes

The implementation expert returns constraints only. It does not
author the specification and does not write the final decision.
