# task-verify-eval-suite: Verify the evaluation suite asserts the new value

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, req-github-pages-publishing, req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, spec-azure-static-web-app, spec-docs-site-workflow, spec-docs-site-azure-pipeline
**Context:** context-factory

## Goal

Confirm that the evaluation checks assert the new value on both CI providers.

## Steps

1. Read `services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.
2. Confirm `githubAzureMatches` asserts `app_location: apps/documentation/build`.
3. Confirm `azureSwaMatches` asserts `app_location: apps/documentation/build`.
4. Confirm the custom-secret checks assert the configured secret name on both providers.
5. Run the full evaluation suite.
6. Record a failure in the change folder. Write no new code.

## Check

Run the full suite. It must be green. Inspect the `github-pages` default checks in the same run.

## Verification scope

- The Static Web App assertions on both providers.
- The custom-secret assertions on both providers.
- The `github-pages` default checks: `githubDefaultHasNoSwa`, `azureDefaultHasNoSwa`, `defaultWorkflowUnchanged`.
- The full suite result.

## Pass criteria

- The suite asserts the new `app_location` value on GitHub Actions.
- The suite asserts the new `app_location` value on Azure Pipelines.
- The suite asserts the configured secret name on both providers.
- The full suite is green.
- The `github-pages` defaults stay unchanged.
