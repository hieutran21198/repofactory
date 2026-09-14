# spec-gate-interface: Three gates accept each provider change

**Master:** [Specifications](README.md)
**Covers:** req-contract-gates
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

This specification defines three acceptance gates for each provider change: contract lint, runtime verification, and breaking-change comparison. It defines each gate as an interface with pass and fail criteria. It defines additive changes and breaking changes. The downstream team selects the gate tools. The tools satisfy the interfaces below.

## Contract

The provider team runs the three gates in order. Each gate gives a pass or fail result. A fail result names the cause. The provider team releases the change only when all three gates pass.

```text
GateResult = { gate: "lint" | "verify" | "breaking-diff",
               verdict: "pass" | "fail",
               details: string }

lint(contract) -> GateResult
verify(contract, provider) -> GateResult
breaking-diff(oldContract, newContract) -> GateResult + ChangeReport

ChangeReport = { added: [operationId],
                 altered: [operationId],
                 removed: [operationId],
                 verdict: "compatible" | "breaking" }
```

Gate 1 — contract lint `lint(contract)`:

- Pass criteria: the file parses, it satisfies the language schema, and it satisfies the conformance criteria of spec-contract-layout.
- Fail criteria: a syntax error, a schema error, a style error that the downstream team marks as an error, or a missing stable operation identifier.
- Tool choice: the downstream team selects the linter. The linter checks at least the pass criteria above.

Gate 2 — runtime verification `verify(contract, provider)`:

- Pass criteria: the running provider serves each operation in the contract, and the request and response shapes match the contract.
- Fail criteria: a missing operation, an extra operation that the contract omits, or a shape difference between the provider and the contract.
- Tool choice: the downstream team selects the verifier. The verifier tests at least each operation that a consumer team can use.

Gate 3 — breaking-change comparison `breaking-diff(oldContract, newContract)`:

- The gate compares the new contract with the last published contract.
- Additive change (compatible, gate passes): the new contract only adds operations, or it adds optional fields. It removes no operation. It alters no required field. It renames no operation identifier.
- Breaking change (gate reports breaking): the new contract removes an operation, renames an operation identifier, alters a required request field, alters a response shape that consumers use, or alters an operation semantic that forces consumer code to change.
- Tool choice: the downstream team selects the diff tool. The tool lists each added, altered, and removed operation. The tool marks the change as compatible or breaking per the rules above.
- Threshold rule: any breaking change fails acceptance for existing consumers. The provider team marks the release as breaking and informs each consumer team. The downstream team defines no numeric threshold that hides a breaking change.

## Errors

| Condition | Response |
| --- | --- |
| The contract has a syntax or style error | The lint gate fails, names the error, and gives the file line when present. |
| The provider does not match its contract | The verification gate fails, names each difference, and names the operation identifier. |
| The new contract removes or alters a used operation | The comparison gate reports a breaking change, lists each removed and altered operation, and blocks consumer acceptance. |
| The new contract only adds compatible operations | The comparison gate passes and lists each added operation. |
| No published baseline exists for comparison | The comparison gate reports no baseline. The provider team publishes the first contract as the baseline without a breaking verdict. |
| A gate tool cannot run | The gate fails with reason `tool-unavailable`. The provider team fixes the tool and reruns all three gates. |
