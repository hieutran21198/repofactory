# task-add-e2e-seed: Add the E2E seed

**Plan:** [Implementation plan](README.md)
**Covers:** req-shared-e2e-folder, spec-e2e-seed

## Goal

Add the shared E2E repository folder to generated projects that use the multiple-repositories architecture.

## Steps

1. Add the seeded E2E README to the module file map.
2. Add the E2E README asset.
3. Add the E2E folder to the root README asset.
4. Define the E2E folder and repository rule in the architecture asset.
5. Add the E2E folder to both generated agent guidance assets.
6. Add a module evaluation check for the E2E file declaration.
7. Check the Nix syntax and the documentation.

## Check

Run the module evaluation check and `git diff --check`.
