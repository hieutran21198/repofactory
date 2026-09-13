# task-eval-guides: Check both CI providers and update the guides

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-publish, spec-docs-site-files, spec-docs-site-azure-pipeline, spec-eval-checks, adr-shared-site-implementation, adr-azure-secret-mapping

## Goal

Prove the Azure pipeline behavior and document the Azure setup for the repository maintainer.

## Steps

1. Extend `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` for both CI providers.
2. Check per-CI file emission and the absence of the other CI file.
3. Check the Azure trigger order, the step order, and the shared bytes.
4. Check empty extension lists, invalid paths, and invalid step relations on both CI providers.
5. Check that `github-actions` defaults, files, and notifications still pass.
6. Update the docs-site guide with the Azure setup and the secret variables.
7. Describe the Pages source step as the one manual step.

## Check

Run the full `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` set and show that all checks pass.
Run a Nix evaluation with CI provider `azure-pipelines` and show the extended configuration results.
Run the notifier regression tests and show that all tests pass.
