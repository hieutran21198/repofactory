# spec-coordination-protocol: Control one change

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The canonical artifact-master role controls one artifact-driven change. It delegates phase content to the expert that owns the phase. It keeps each phase output in one commit.

## Contract

The role must contain a `Plan-Pn then Build-Pn` procedure with these rules:

- Plan-P1 reads the business need or the change reason.
- Plan-P2, Plan-P3, and Plan-P5 read only the committed output of the prior phase.
- A plan is read-only. It stops for explicit user approval before its build starts.
- Phase 1 routes to the requirement expert.
- Phases 2, 3, and 5 route to the solution expert.
- Phase 4 routes each component task to its implementation expert.
- For an uncovered phase 4 component, the solution expert helps select an owner.
- The artifact master does not write requirements, specifications, decisions, tasks, code, tests, or versions. It checks that the phase owner completed the approved work.
- Each build writes only its phase output and ends with one commit for that phase.
- A later phase does not start before the prior phase commit exists.
- Phase 4 has no Plan-P4. It starts only from the implementation plan approved in phase 3.

The role must keep a `coordinate-plan` in the chat only. It must not put the coordinate-plan in `tasks/`. The solution expert alone writes the phase 3 execution plan.

## Errors

- If the prior phase input or its commit is absent, stop and request the missing input.
- If a content choice needs a decision, identify the phase owner that needs the user answer.
- If no implementation expert covers a phase 4 component, route the owner selection to the solution expert.
