# adr-designer-harness: Render the designer expert as a content role

**Relates to:** spec-designer-expert, spec-parallel-design
**Context:** context-factory

## Context

The designer expert owns one phase 2 artifact. The artifact master owns all expert coordination.
The harness declaration must keep these ownership boundaries.

## Options

1. Render a conditional built-in content role. Use subagent mode and deny task permission. Pro:
   The role has clear artifact ownership. Pro: The artifact master remains the coordinator. Con:
   The factory must render and check one more role.
2. Add design instructions to the solution expert. Pro: Phase 2 has one role. Con: Design has no
   separate owner. Con: The solution and design work cannot run in parallel.
3. Render the designer expert as a selectable coordinator. Pro: A user can start it directly.
   Con: The harness has two phase coordinators. Con: This conflicts with artifact-master ownership.

## Decision

Select option 1. Render `designer-expert` only when UX Design is on. For OpenCode, use
`mode = "subagent"` and declared task permission `deny`. Use the artifact master for all routes.

Use the existing `mkRole` renderer. Add the role with a conditional attribute set. Add the
OpenCode denial in an enable-gated `lib.mkIf` merge. Append UX Design chapters after the optional
Domain-Driven Design chapter. Keep all base role bodies unchanged.

## Feasibility constraints and resolutions

| ID | Constraint | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- |
| UX-C-01-2 | On-output is `lib.mkIf` merge: add `designer-expert` to `role.builder` + OpenCode deny gated by enable; `mkRole` already subagent. | Composition lines 339-413. | `spec-ux-design-option` and `spec-designer-expert`. | `factory-expert` | Use one enable-gated composition merge. Reuse `mkRole` for subagent mode and add the gated OpenCode denial. |
| UX-C-03-1 | Phase rules in role bodies not options: add second optional chapter to `mkRole` keyed on enable (DDD is first); do not edit base bodies. | Composition lines 343-353, release role line 38, and exact role-body evaluations. | Phase rule delivery. | `factory-expert` | Append the UX Design chapter after the optional DDD chapter. Keep each base role body unchanged. |
| UX-C-04-1 | Reuse renderer: add `designer-expert` to `builtinRoles` only when enabled; `mkRole` subagent; body at `composition/_assets/agent/role/designer-expert/ROLE.md` (body only). | Composition lines 343-354 and 373-378; role renderer lines 82-113. | `spec-designer-expert` role delivery. | `factory-expert` | Add a conditional built-in role and a body-only source file. Use the existing renderer for all selected harnesses. |
| UX-C-04-2 | Extend eval lists for on-fixtures only; existing off fixtures stay valid. | Evaluation lines 376-380 and related exact checks. | Role evaluation contract. | `factory-expert` | Add enabled fixture lists for the designer expert. Do not change the expected role lists of off fixtures. |
| UX-C-05-1 | Ownership boundary authored text only in designer `ROLE.md` + Design template; no option. | Factory role and template delivery. | `spec-design-ownership`. | `factory-expert` | Put the ownership rules in the conditional role and template. Add no ownership option. |
| UX-C-06-1 | Parallel sequence needs master+solution role text, no Nix option; enabled text appends conditionally. | Artifact-master role lines 16-20 and the `mkRole` append path. | `spec-parallel-design`. | `factory-expert` | Put the route and join in the artifact-master chapter. Put the content sequence in the solution-expert chapter. Append both only when enabled. |

## Consequences

The role can work in parallel with the solution expert. It cannot coordinate another expert. Each
selected harness receives the same instruction body with its applicable declaration. Off fixtures
keep their exact role output.
