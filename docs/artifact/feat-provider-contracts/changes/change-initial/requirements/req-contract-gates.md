# req-contract-gates: Contract gates accept each change

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

Each provider change must pass three gates before consumers accept it: contract lint, runtime
verification, and breaking-change comparison.

## Acceptance criteria

- Given a contract with a syntax or style error, when the provider team runs contract lint, then the lint gate fails and names the error.
- Given a provider that does not match its contract, when the provider team runs runtime verification, then the verification gate fails and names the difference.
- Given a new contract that removes or alters a used operation, when the provider team compares it with the last published contract, then the comparison gate reports a breaking change.
- Given a new contract that only adds compatible operations, when the provider team compares it with the last published contract, then the comparison gate passes.

## Notes

The gates are acceptance gates on provider changes. Their implementation and thresholds belong to
Phase 2. Assumption: three gates are sufficient and no consumer-side gate is necessary. This
assumption needs user confirmation.
