# req-ddd-guidance: Give one design guide for DDD

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

A project that selects DDD must get one design guide that covers the strategic design first
and the tactical design second.

## Acceptance criteria

- Given the design guide, when a user reads the strategic part, then it defines the subdomain types, the bounded context, the ubiquitous language, and the context map with its relationship types.
- Given the design guide, when a user reads the tactical part, then it defines the aggregate, the entity, the value object, the domain event, the command, the policy, the domain service, and the repository.
- Given the design guide, when a user reads it, then it gives a table that maps the subdomain type to an implementation pattern.
- Given the design guide, when a user reads it, then it says that the strategic design comes before the tactical design.
- Given a project that uses the artifact-driven documentation model, when a user reads the design guide, then it finds a page that maps each DDD step to one of the five phases.

## Notes

Sources: Evans, *Domain-Driven Design*; Vernon, *Implementing Domain-Driven Design*;
Khononov, *Learning Domain-Driven Design*; the ddd-crew canvases.
