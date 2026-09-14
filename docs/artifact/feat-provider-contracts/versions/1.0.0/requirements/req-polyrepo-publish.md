# req-polyrepo-publish: Provider publishes its contract

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

Each provider team must publish its contract with each release. Each consumer team must find the
current contract of each provider that it uses.

## Acceptance criteria

- Given a new provider release, when a consumer team requests the contract, then the consumer team receives the contract that matches the release.
- Given two releases of one provider, when a consumer team compares their contracts, then the consumer team can list each added, altered, and removed operation.
- Given a provider with no new release, when a consumer team requests the contract, then the consumer team receives the last published contract.

## Notes

The publication place and the contract version rule belong to Phase 2. Assumption: publication
with each release is sufficient and no central registry is necessary. This assumption needs user
confirmation.
