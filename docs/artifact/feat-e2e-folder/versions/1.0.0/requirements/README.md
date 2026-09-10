# Requirements: E2E folder

## Business need

Project teams need one known location for end-to-end tests that use more than one component.
The repository architecture must make this location available in each generated project.

## Scope

- In scope: Add and document the shared `e2e/` repository folder.
- Out of scope: Select an end-to-end test framework or add end-to-end tests.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-shared-e2e-folder](req-shared-e2e-folder.md) | Generated projects must include one shared `e2e/` repository folder. | Must |

## Acceptance

The many-repository architecture seeds `e2e/README.md` and documents `e2e/` in all generated guidance.
