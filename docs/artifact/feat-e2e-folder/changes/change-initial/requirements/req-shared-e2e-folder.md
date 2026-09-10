# req-shared-e2e-folder: Add the shared E2E folder

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The many-repository architecture must include one shared `e2e/` repository folder.

## Acceptance criteria

- Given the many-repository architecture, when the generator configures its files, then it includes `e2e/README.md`.
- Given generated project guidance, when a user reads it, then it identifies `e2e/` as one shared repository.
- Given the E2E README, when a user reads it, then it identifies cross-component workflows as its test scope.

## Notes

The shared repository can test workflows across applications and services.
