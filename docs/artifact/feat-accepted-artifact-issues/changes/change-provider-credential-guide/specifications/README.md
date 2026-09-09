# Specifications: Provider credential guide

## Solution

The project-issues composition generates a separate credential guide. The guide gives safe setup,
check, rotation, and revocation procedures for GitHub Projects and Trello credentials. It explains
all token and secret names that the generated workflow uses.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-provider-credential-guide](spec-provider-credential-guide.md) | Generate credential procedures for both providers. | req-provider-adapters |

## Decisions

- [Generate one provider credential guide](../decisions/adr-generated-credential-guide.md)
