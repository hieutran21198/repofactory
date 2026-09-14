# req-provider-contract: Provider owns its wire contract

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

Each polyrepo component with a wire surface must have one machine-readable contract. The provider
team must own the contract and keep it accurate with each change.

## Acceptance criteria

- Given a polyrepo component with a wire surface, when a consumer team reads its contract, then the contract describes each operation that the consumer can use.
- Given a provider change that alters the wire surface, when the provider team releases the change, then the contract reflects the new wire surface.
- Given a wire surface with no consumer, when the provider team reviews it, then no contract is necessary.

## Notes

OpenAPI is the primary contract language. AsyncAPI, Protobuf, and JSON Schema are allowed
alternatives. Phase 2 selects the language for each wire surface. No schema is part of this
change. Assumption: each polyrepo component maps to the factory context only. This assumption
needs user confirmation.
