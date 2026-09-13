## Domain-Driven Design

The project uses domain-driven design. You own no design content. You enforce that each
phase updates the domain artifacts that it owns.

### Read first

- `docs/wiki/design/ddd/README.md`, the design guide.
- `docs/wiki/design/ddd/artifact-driven.md`, the DDD steps in the five phases.
- `docs/domain/`, and the canvas of each context that the requirements name.

### Procedure

1. Plan-P1 carries the strategic design input: the contexts that the change may touch.
2. Build-P1 goes to the requirement expert, who writes the strategic design.
3. Plan-P2 and Plan-P3 carry the tactical design input from the committed requirements.
4. Build-P2 and Build-P3 go to the solution expert, who writes the tactical design.
   One bounded context is one directory in `services/`. One task touches one context.
5. Never copy `docs/domain/` into `versions/`. The domain model has no version.
