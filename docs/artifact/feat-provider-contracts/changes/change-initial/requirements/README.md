# Requirements: Provider contracts

**Change:** [Initial](../../../changes/change-initial/README.md)

## Business need

Provider teams own polyrepo components and deploy them independently. Consumer teams use the wire
surface of those components. Today a provider wire change breaks a downstream consumer without
detection. Provider teams need to own a machine-readable contract for each wire surface.
Consumer teams need acceptance gates that find breaking changes before deployment.

## Scope

- In scope: One provider-owned, machine-readable contract for each polyrepo component wire surface.
- In scope: OpenAPI as the primary contract language. AsyncAPI, Protobuf, and JSON Schema are allowed alternatives. Phase 2 selects the language for each wire surface.
- In scope: Three acceptance gates: contract lint, runtime verification, and breaking-change comparison.
- In scope: Publication of each contract so consumer teams can compare it before they deploy.
- Out of scope: The contract schemas and the gate implementation. Phase 2 specifies them.
- Out of scope: Code, tests, and deployment pipelines.
- Out of scope: Bounded contexts other than context-factory.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Provider team, Consumer team, Repository maintainer | Provider contract published, Breaking change detected, Contract gate failed |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-provider-contract](req-provider-contract.md) | Each provider component must own one machine-readable contract for its wire surface. | Must |
| [req-contract-gates](req-contract-gates.md) | Each provider change must pass contract lint, runtime verification, and breaking-change comparison. | Must |
| [req-polyrepo-publish](req-polyrepo-publish.md) | Each provider team must publish its contract so consumer teams can compare it before they deploy. | Must |

## Acceptance

Each polyrepo component with a wire surface has one provider-owned, machine-readable contract.
Each provider change passes contract lint, runtime verification, and breaking-change comparison.
A consumer team finds a breaking provider change before it deploys.
