# req-expert-routing: Route each phase to its owner

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must route phase 1 to the requirement expert. It must route phases 2, 3, and
5 to the solution expert. It must route phase 4 to each implementation expert for the applicable
component. If no implementation expert covers a component, the solution expert must help select
the owner of that work.

## Acceptance criteria

- Given phase 1, when its build starts, then the requirement expert owns its content.
- Given phase 2, phase 3, or phase 5, when its build starts, then the solution expert owns its content.
- Given phase 4 and a covered component, when its build starts, then its implementation expert owns the work.
- Given phase 4 and an uncovered component, when the artifact master routes the work, then the solution expert helps select its owner.

## Notes

One bounded context maps to one component in a project that uses domain-driven design.
