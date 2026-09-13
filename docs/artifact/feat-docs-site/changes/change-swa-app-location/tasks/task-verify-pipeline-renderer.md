# task-verify-pipeline-renderer: Verify the Azure Pipelines deploy inputs

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, spec-azure-static-web-app, spec-docs-site-azure-pipeline
**Context:** context-factory

## Goal

Confirm that the Azure Pipelines renderer emits the corrected deploy pair.

## Steps

1. Read `publishStep` in `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Confirm `app_location` is `apps/documentation/build`.
3. Confirm `output_location` is `build` and `skip_app_build` is `true`.
4. Confirm the task is `AzureStaticWebApp@0`.
5. Confirm the token input reads `$(<api-token-secret>)`.
6. Record a mismatch in the change folder. Write no new code.

## Check

Render the pipeline with `target = "azure-static-web-app"`. Inspect `azure-pipelines/docs-site.yml`.

## Verification scope

- The `publishStep` value for the Static Web App target only.
- The generated file `azure-pipelines/docs-site.yml` with the Static Web App target.
- No other pipeline line.

## Pass criteria

- `app_location` is `apps/documentation/build`.
- `output_location` is `build` for shape-compatibility.
- `skip_app_build` is `true`.
- The task is `AzureStaticWebApp@0`.
- The token input reads the configured secret variable.
- The `github-pages` shape does not change.
