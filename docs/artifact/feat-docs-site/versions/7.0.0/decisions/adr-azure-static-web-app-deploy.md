# adr-azure-static-web-app-deploy: Deploy to Static Web Apps with the official deploy action and task

**Relates to:** spec-azure-static-web-app
**Context:** context-factory

## Context

The generated pipelines must upload `apps/documentation/build` to Azure Static Web Apps. The factory already builds the site with `npm run build`. The deploy mechanism must only upload the result. It must run on GitHub Actions and on Azure Pipelines with the same result.

## Options

1. Deploy with the official mechanisms: `Azure/static-web-apps-deploy@v1` on GitHub Actions and `AzureStaticWebApp@0` on Azure Pipelines. Pro: Microsoft maintains the upload, the token handling, and the output reporting. The configuration stays small. Con: The factory depends on two marketplace actions.
2. Deploy with a shell script that calls the Static Web Apps CLI (`swa deploy`) on both providers. Pro: One script serves both providers with no marketplace dependency. Con: The factory must install the CLI, manage its version, and map its flags on each provider.

## Decision

Deploy with the official mechanisms: `Azure/static-web-apps-deploy@v1` on GitHub Actions and `AzureStaticWebApp@0` on Azure Pipelines. Both use `app_location: apps/documentation/build`, `output_location: build`, and `skip_app_build: true`. Both read the deployment token from the configured secret.

## Consequences

The pipelines stay small and use supported upload paths. The extension hooks and the notification reuse do not change. The evaluation must check the action name, the task name, the three location inputs, and the token mapping on both providers.
