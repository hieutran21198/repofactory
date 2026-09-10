# spec-e2e-seed: Define the E2E seed

**Master:** [Specifications](README.md)
**Covers:** req-shared-e2e-folder

## Description

The multiple-repositories module seeds an E2E README and identifies its repository boundary.
The generated guidance uses the same E2E description.

## Contract

When `repo-arch.use` is `multiple`, the module adds this file declaration:

```nix
"e2e/README.md" = {
  source = ./_assets/e2e/README.md;
  copyMode = "seed";
};
```

The E2E README identifies `e2e/` as the shared location for cross-component workflow tests.
The root README, architecture page, and agent guidance also identify this location.

In a polyrepo layout, the complete `e2e/` directory points to one repository.

## Errors

Nix evaluation fails if the E2E README source does not exist.
The check fails if another repository architecture emits the E2E seed.
