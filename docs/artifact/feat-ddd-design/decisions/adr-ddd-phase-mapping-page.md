# adr-ddd-phase-mapping-page: Map the DDD steps to the phases in a composition page

**Relates to:** spec-composition-guidance

## Context

The artifact-driven model page defines the five phases. The DDD steps must be visible in the
phases, but the documentation module must not know about design.

## Options

1. Emit one page `docs/wiki/design/ddd/artifact-driven.md` from the composition. Pro: the base
   model page does not change, the page exists only when both models are on. Con: the reader
   follows one link from the agent guidance.
2. Force a DDD-aware copy of the model page from the composition. Pro: one page. Con: more
   than 100 lines exist two times and the two copies drift.

## Decision

Emit one page from the composition.

## Consequences

The agent guidance and the wiki index link to the page. The base model page stays the same for
all projects.
