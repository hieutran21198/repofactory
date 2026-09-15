# adr-repository-blueprint-pattern: Keep the domain model pattern

**Relates to:** spec-coordination-protocol
**Context:** context-factory

## Context

The repository blueprint enforces rules across selected repository compositions. The artifact master behavior adds rules for generated roles and skills.

## Options

1. Use a domain model. Pro: The aggregate can enforce related blueprint rules together. Con: The model needs explicit invariants.
2. Use a transaction script. Pro: The composition action is direct. Con: Related rules can spread across scripts.

## Decision

Select option 1. Keep the domain model pattern because one repository blueprint owns the related role, skill, and harness delivery rules.

## Consequences

The aggregate canvas records the added invariants and generated result. Composition code must keep the rules at the repository blueprint boundary.
