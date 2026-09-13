# task-validation-guides-checks: Add validation, guides, and tests for Azure Pipelines

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-sync, spec-azure-pipelines-sync, spec-composition-options, spec-factory-options, spec-ci-cd-provider, adr-shared-sync-implementation, adr-azure-secret-mapping

## Goal

Validation, setup guides, and tests cover the Azure Pipelines selection.

## Steps

1. Accept only `github-actions` and `azure-pipelines` as CI values when the composition is enabled.
2. Apply no composition preconditions when the composition is disabled.
3. Validate each secret name and keep the one-to-one secret mapping for Azure.
4. Extend the setup guide with Azure secret variables and keep adapter code CI-independent.
5. Tell the Azure user to mark each mapped variable as secret.
6. Extend `services/factory/composition/artifact-driven/tests/eval.nix` with `ciProvider azure-pipelines` cases for GitHub Projects, Trello, split boards, and all notification providers.
7. Keep all existing `github-actions` test expectations unchanged.

## Check

- Run the full composition `eval.nix` test set and show that all assertions pass.
- Show secret-mapping validation with a valid name and with an invalid name.
- Show that an unsupported CI value stops Nix evaluation when the composition is enabled.
- Show that a disabled composition emits no files and applies no preconditions.
- Show that GitHub Actions workflow bytes are identical to version 8.1.0 for the same settings.
