# task-verify-workflow-renderer: Verify the GitHub Actions deploy inputs

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, req-github-pages-publishing, req-generated-assets, spec-azure-static-web-app, spec-docs-site-workflow
**Context:** context-factory

## Goal

Confirm that the GitHub Actions renderer emits the corrected deploy pair.

## Steps

1. Read `azureDeployStep` in `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Confirm `app_location` is `apps/documentation/build`.
3. Confirm `output_location` is `build` and `skip_app_build` is `true`.
4. Confirm the step uses `Azure/static-web-apps-deploy@v1`.
5. Confirm the token input reads `${{ secrets.<api-token-secret> }}`.
6. Record a mismatch in the change folder. Write no new code.

## Check

Render the workflow with `target = "azure-static-web-app"`. Inspect `.github/workflows/docs-site.yml`.

## Verification scope

- The `azureDeployStep` value only.
- The generated file `.github/workflows/docs-site.yml` with the Static Web App target.
- No other workflow line.

## Pass criteria

- `app_location` is `apps/documentation/build`.
- `output_location` is `build` for shape-compatibility.
- `skip_app_build` is `true`.
- The action is `Azure/static-web-apps-deploy@v1`.
- The token input reads the configured secret name.
- The `github-pages` shape does not change.
