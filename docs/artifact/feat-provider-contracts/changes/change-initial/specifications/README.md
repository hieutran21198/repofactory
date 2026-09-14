# Specifications: Provider contracts

**Change:** [Initial](../../../changes/change-initial/README.md)

## Solution

The solution adds provider-owned contracts to the factory context. The `services/factory` component owns the contract layout, the gate interface, and the publish rule. The provider team owns one machine-readable contract for each wire surface. The provider team runs three acceptance gates before each release. The provider team publishes the contract with each release. The consumer team reads the current contract and compares releases before it deploys. The downstream team selects the contract language and the gate tools within the allowed set.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-contract-layout](spec-contract-layout.md) | One owned machine file for each wire surface. | req-provider-contract |
| [spec-gate-interface](spec-gate-interface.md) | Three gates with pass and fail criteria. | req-contract-gates |
| [spec-publish-rule](spec-publish-rule.md) | Per-release publication and consumer read path. | req-polyrepo-publish |

## Decisions

- [adr-contract-selection](../decisions/adr-contract-selection.md)
- [adr-publish-place](../decisions/adr-publish-place.md)
