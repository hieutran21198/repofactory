# adr-blueprint-pattern: Use a domain model for repository blueprints

**Relates to:** spec-factory-options
**Context:** context-factory

## Context

The repository factory is a core subdomain. Its composition rules and invariants change as the
factory gets more domains and providers.

## Options

1. Use a transaction script. Pro: The first implementation is small. Con: Rules spread across provider scripts.
2. Use a domain model. Pro: One blueprint model owns selection and artifact rules. Con: The model needs more explicit types.

## Decision

Use a domain model. Keep provider API operations in adapters outside the model.

## Consequences

The repository blueprint owns generated-file invariants. Provider adapters own external API details.
