# adr-publish-place: Per-release publication versus central registry

**Context:** context-factory
**Relates to:** spec-publish-rule

## Context

Consumer teams must find the current contract of each provider before they deploy. The project must decide where provider teams publish contracts.

## Options

1. Central registry. Each provider team pushes its contract to one registry service. Consumer teams read from the registry. Pro: one read path for all providers. Con: the project must build and run a new service, and each release needs registry synchronization.
2. Per-release publication. Each provider team publishes its contract with each release as a release asset. Consumer teams read the asset by release tag. Pro: no new service, the contract always matches the release, and comparison uses release tags. Con: the consumer team must know each provider release place, and no single index lists all contracts.

## Decision

We select option 2, per-release publication. The user agrees that per-release publication is sufficient. No central registry is necessary for this change.

## Consequences

- Each release ships its contract files as release assets.
- The consumer team reads the contract by release tag.
- A future change can add a central index without changing the publish rule.
