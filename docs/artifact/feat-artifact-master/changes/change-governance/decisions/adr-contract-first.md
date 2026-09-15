# adr-contract-first: Keep specification ownership with the solution expert

**Relates to:** spec-contract-driven, spec-interactive-recommend, spec-parallel-implementation
**Context:** context-factory

## Context

Phase 2 needs a contract before implementation detail. An implementation expert knows the
feasibility limits of its component. The solution expert owns the master specification and the
final decision. The review sequence must keep these ownership boundaries.

## Options

1. Let each implementation expert write its component specifications and let the solution expert
   merge them. Pro: The author has direct component knowledge. Con: The implementation expert
   owns specification content. Con: Names and contracts can conflict.
2. Let the solution expert write the contract first. Then let the implementation expert return
   feasibility constraints. Pro: Specification ownership stays with the solution expert. Pro:
   Component limits enter the decision before final content. Con: The review needs one additional
   exchange for each affected component.

## Decision

Select option 2. The solution expert writes the interface, events, and data model first. It sends
that contract to the applicable implementation expert. The implementation expert returns
constraints only. The solution expert resolves them, keeps names consistent, and writes the final
specification and decision.

If the expert finds a correction or better path, it uses the option interview before the final
write. If only one path is feasible, it presents that path directly.

## Feasibility constraints

No `services/factory` implementation expert returned constraints during phase 2. The following
constraints are explicit assumptions from repository evidence.

| ID | Constraint and evidence | Responsible owner | Resolution |
| --- | --- | --- | --- |
| C1 | The current solution-expert role owns phases 2, 3, and 5. The new route removes phase 5 ownership only. | `services/factory` implementation owner | Keep phases 2 and 3 in the role. Replace phase 5 procedure with the readiness gate. |
| C2 | The solution-expert role currently asks implementation experts to supply specification and task content. | `services/factory` implementation owner | Change phase 2 so implementation experts return constraints only. Keep phase 4 ownership unchanged. |
| C3 | The factory has no built-in implementation expert for `services/factory`. The expert-role skill makes project-specific experts. | Solution expert | Identify the `services/factory` implementation owner in phase 3. Give that owner each assumption to verify. |
| C4 | The Nix composition uses canonical role text and optional DDD chapters. | `services/factory` implementation owner | Put common governance rules in canonical role text. Put only DDD-specific rules in DDD chapters. |
| C5 | The current evaluation uses text assertions for role and page contracts. | `services/factory` implementation owner | Add assertions for contract sections, constraint ownership, option interviews, and `can-parallel`. |
| C6 | Each change artifact is a full replacement file. | Solution expert | Keep the same filename for each replaced specification. Add a new filename only for a new contract. |
| C7 | `context-factory` is the only context. The context map has no relationship or shared code. | Solution expert | Record no upstream-to-downstream context relation and add no library. |
| C8 | The Repository blueprint already uses the Domain model pattern. | Solution expert | Keep that pattern and add governance delivery invariants to the existing aggregate. |
| C9 | No code or evaluation ran during phase 2. | `services/factory` implementation owner | Verify these assumptions before phase 4 ends. Return an artifact correction if one is false. |
| C10 | The requirement-expert and solution-expert role assets need the same option interview fields. | `services/factory` implementation owner | Add one option interview contract to both role bodies. |
| C11 | The artifact-master role already owns user choices and phase approval messages. | `services/factory` implementation owner | Add the mid-build approval gate to that role. |
| C12 | The repository must not contain a record of chat messages. | Requirement expert and solution expert | Keep the option interview and its choice in chat only. |
| C13 | The current phase 3 task contract has no dependency or `can-parallel` field. | `services/factory` implementation owner | Add both fields to the solution-expert role and the task template contract. |
| C14 | The artifact master starts phase 4 from the approved phase 3 plan. | Artifact master | Make ordered work batches from the approved task data. |
| C15 | Phase 4 must keep one commit when tasks run in parallel. | Artifact master | Join all task results before the phase 4 commit. |
| C16 | One canonical artifact-master role body supplies phase messages to all harnesses. | `services/factory` implementation owner | Add new message fields to the canonical body and verify every rendered role. |
| C17 | Every selected harness must receive each required built-in role. | `services/factory` implementation owner | Extend the existing rendered-role checks to the artifact release expert. |

## Consequences

Each changed specification starts with a testable contract. Each code, pattern, or context-map
change has named constraints and an owner. The implementation expert does not become a
specification author. Phase 3 must assign the `services/factory` implementation owner and include
constraint verification in its tasks.
