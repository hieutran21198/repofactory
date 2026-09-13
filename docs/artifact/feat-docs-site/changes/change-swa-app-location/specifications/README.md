# Specifications: Documentation site

**Change:** [Point SWA app_location at build output](../../../changes/change-swa-app-location/README.md)

## Solution

With `skip_app_build: true`, the Static Web App mechanisms ignore `output_location`. They read the app artifacts directly from `app_location`. Thus `app_location` is `apps/documentation/build`, the Docusaurus build output. The composition keeps `output_location: build` only for shape-compatibility. The build part does not change. The `github-pages` contract does not change. The target option, the secret mapping, and the notifications do not change.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-azure-static-web-app](spec-azure-static-web-app.md) | Correct the Static Web App deploy inputs on both CI providers. | req-azure-static-web-app |
| [spec-docs-site-workflow](spec-docs-site-workflow.md) | Correct the Static Web App deploy step of the GitHub Actions workflow. | req-github-pages-publishing, req-generated-assets, req-azure-static-web-app |
| [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) | Correct the Static Web App task inputs of the Azure pipeline. | req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app |

Only the specifications that change are present in this change folder.
