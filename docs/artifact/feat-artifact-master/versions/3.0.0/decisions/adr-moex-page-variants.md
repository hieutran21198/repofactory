# adr-moex-page-variants: Use one page for all repository layouts

**Relates to:** spec-moex-page, spec-moex-delivery
**Context:** context-factory

## Context

The factory supports single and multiple repository layouts. Each layout can use DDD. The
mixture-of-experts explanation does not need DDD-specific terms. The factory must keep the page
content equal in each generated repository.

The Repository blueprint keeps the Domain model pattern that
`adr-repository-blueprint-pattern` selects.

## Options

1. Use one canonical page and one mirror for each repository layout. Pro: All layouts receive the
   same explanation. Con: The page cannot contain layout-specific or DDD-specific instructions.
2. Use separate pages for the DDD and non-DDD variants. Pro: Each page can contain variant-specific
   instructions. Con: The pages can diverge and need duplicate checks.

## Decision

Select option 1. The required explanation is the same for all layouts. The single and multiple
mirrors contain the canonical page. Each DDD variant uses the mirror of its repository layout.

## Consequences

The factory checks one content contract for all four layout combinations. A future
variant-specific requirement needs a new decision and separate page mirrors.
