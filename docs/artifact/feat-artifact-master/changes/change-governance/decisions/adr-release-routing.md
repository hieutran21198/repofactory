# adr-release-routing: Separate release copy from the version gate

**Relates to:** spec-release-role, spec-coordination-protocol, spec-harness-delivery, spec-verification-contract, spec-moex-page
**Context:** context-factory

## Context

Phase 5 must route to the artifact release expert. The solution expert must keep the version gate
only. The existing contracts route phase 5 to the solution expert. The new route affects a
built-in role, a skill, verification, and copied wiki content.

The specification set can add separate governance contracts or consolidate all rules into the
existing contracts. Both approaches must remove the old route from the full feature state.

## Options

1. Use a hybrid specification set. Add four focused governance specifications and replace each
   conflicting specification. Pro: Each governance rule has a testable contract. Pro: The full
   feature state has no old route. Con: Phase 2 changes more specification files.
2. Consolidate all governance rules into the existing specifications. Pro: The change adds no
   teardown specification. Con: Large contracts combine unrelated rules. Con: Requirement and
   test traceability is less direct.

## Decision

Select option 1. The focused specifications define each new rule. The replacement specifications
remove the old route and keep the full feature contract consistent.

The artifact master routes phase 5 after the solution expert confirms readiness. The artifact
release expert copies, deletes, updates the feature README, and verifies the result. It does not
edit a copied artifact or run a domain-driven design step.

## Feasibility constraints

No `services/factory` implementation expert returned constraints during phase 2. The following
constraints are explicit assumptions from repository evidence.

| ID | Constraint and evidence | Responsible owner | Resolution |
| --- | --- | --- | --- |
| R1 | `builtinRoles` has requirement, solution, and artifact-master roles. It has no artifact release expert. | `services/factory` implementation owner | Add `artifact-release-expert` through the existing built-in role interface. |
| R2 | `mkRole` renders a built-in role for each selected harness and uses `subagent` for content experts. | `services/factory` implementation owner | Use `mkRole` and keep the new role as a content expert. |
| R3 | The artifact-master role and skill route phases 2, 3, and 5 to the solution expert. | `services/factory` implementation owner | Route only phases 2 and 3 to the solution expert. Route phase 5 to the artifact release expert. |
| R4 | The role evaluation has fixed `roles` and `expertRoles` lists with old route assertions. | `services/factory` implementation owner | Add the release role and replace each old route assertion. |
| R5 | The canonical mixture-of-experts page and two repository-layout mirrors contain the old route. | `services/factory` implementation owner | Update the canonical page and both mirrors with equal content. |
| R6 | The single and multiple DDD page mirrors name the solution expert as the phase 5 owner. | `services/factory` implementation owner | Update both DDD page mirrors. |
| R7 | Phase 5 uses copy and delete operations, but the feature README also needs required line and link changes. | Artifact release expert | Treat the required feature README update as the mechanical phase 5 output. Do not edit copied artifacts. |
| R8 | No code or evaluation ran during phase 2. | `services/factory` implementation owner | Verify all assumptions with the phase 4 checks before the commit. |
| R9 | The artifact-master skill is a thin loader for the rendered coordinator role. | `services/factory` implementation owner | Keep the coordination body out of the skill and change only its phase route summary. |
| R10 | The artifact-master skill is the current delegating coordination skill. | `services/factory` implementation owner | Do not add an artifact-release-expert skill unless phase 4 finds a harness constraint. |

## Consequences

The factory has one additional built-in content expert. Every selected harness receives its
rendered role. The artifact-master skill, the wiki mirrors, and the tests must use the same route.
The solution expert can block release but cannot make the version copy.
