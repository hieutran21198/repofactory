# adr-contract-first: Route feasibility through the artifact master

**Relates to:** spec-contract-driven, spec-coordination-protocol, spec-verification-contract
**Context:** context-factory

## Context

The solution expert owns each specification and final decision. The implementation expert owns
component feasibility knowledge. The artifact master owns all coordination. The feasibility
sequence must keep all three ownership boundaries.

## Options

1. Let the solution expert send each contract directly to the implementation expert. Pro: The
   review uses one exchange. Con: The solution expert must coordinate another expert. Con: This
   route gives spawning to a content expert.
2. Let the solution expert send each contract to the artifact master for routing. Pro: The
   artifact master keeps all coordination. Pro: The solution expert keeps specification content.
   Con: The review uses one more routing exchange.

## Decision

Select option 2. The solution expert writes the contract first and sends it to the artifact
master. The artifact master sends the unchanged contract to the applicable implementation expert.
It returns the constraints to the solution expert. The solution expert resolves each constraint
and writes the final specification and decision.

## Feasibility constraints and resolutions

| ID | Constraint | Responsible owner | Resolution |
| --- | --- | --- | --- |
| C1 | The solution-expert role must prohibit subagent and direct expert calls while it keeps phases 2 and 3 ownership. | `factory-expert` | Replace direct consultation steps with requests to the artifact master. Keep the phase 5 readiness gate. |
| C2 | The artifact-master route must preserve the complete contract and its review identifier. | `factory-expert` | Use one feasibility-review envelope. Route the contract without edits. |
| C3 | Returned constraints must preserve evidence, affected items, and responsible owners. | `factory-expert` | Require the same review identifier and constraint fields on the return route. |
| C4 | An implementation expert must return constraints only. It must not author specifications, decisions, or tasks. | `factory-expert` | Put the rule in the applicable canonical text and both tracked project-local role bodies. Apply the local-only exclusion in F9. |
| C5 | Nix text checks can inspect role and skill instructions. They cannot prove that decision records are complete. | `factory-expert` | Limit this check to role-text and skill-text assertions for the contract-first route and no-subagent rule. |

Each constraint has a responsible owner and a contract resolution. The solution expert keeps the
master specification and the final decision.

## Consequences

The review has one more routing step. The artifact master owns transport only. The solution expert
keeps the master specification, resolves conflicts, and writes the final decision.
