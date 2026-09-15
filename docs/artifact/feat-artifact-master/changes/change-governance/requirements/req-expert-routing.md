# req-expert-routing: Route each phase to its owner

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must route phase 1 to the requirement expert. It must
route phases 2 and 3 to the solution expert. It must route phase 5 to the
artifact release expert. It must route phase 4 to each implementation expert
for the applicable component. If no implementation expert covers a component,
the solution expert must help select the owner of that work. The solution
expert must keep the version gate only. It must confirm that the change is
ready for release.

## Acceptance criteria

- Given phase 1, when its build starts, then the requirement expert owns its content.
- Given phase 2 or phase 3, when its build starts, then the solution expert owns its content.
- Given phase 5, when its build starts, then the artifact release expert owns the version copy.
- Given phase 5, when the artifact master routes the work, then the solution expert confirms readiness only and does not copy files.
- Given phase 4 and a covered component, when its build starts, then its implementation expert owns the work.
- Given phase 4 and an uncovered component, when the artifact master routes the work, then the solution expert helps select its owner.

## Notes

One bounded context maps to one component in a project that uses
domain-driven design. The version gate is the readiness check before the
release copy starts.
