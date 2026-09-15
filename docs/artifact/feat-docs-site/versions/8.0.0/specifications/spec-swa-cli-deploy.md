# spec-swa-cli-deploy: Deploy with the pinned Static Web Apps CLI

**Master:** [Specifications](README.md)
**Covers:** req-swa-deploy-tool, req-swa-cli-pinned
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The factory pins Static Web Apps CLI version `2.0.10`. The `swa-cli`
selection installs this version and uploads the existing Docusaurus build
output. The project cannot select or change the CLI version.

The CLI deploy shape replaces only the official deploy action or task. The
site build, hooks, extension points, token setting, and notification contract
do not change.

## Contract

### Factory pin

| Package | Version | Install command |
| --- | --- | --- |
| `@azure/static-web-apps-cli` | `2.0.10` | `npm install --global @azure/static-web-apps-cli@2.0.10` |

The factory keeps the package name and version in the docs-site composition.
A factory update can change the pin without a project configuration change.

### Common deploy command

Both providers run this command from `apps/documentation`:

```sh
swa deploy ./build --deployment-token "$SWA_CLI_DEPLOYMENT_TOKEN" --env production
```

The positional `./build` value is the CLI output location. Because the
working directory is `apps/documentation`, the command uploads
`apps/documentation/build`. The command does not run `swa build` and does not
build the site again. The `--env production` option prevents the CLI default
preview deployment.

The deploy step receives `SWA_CLI_DEPLOYMENT_TOKEN` from the configured
`azure-static-web-app.api-token-secret`. It does not print the token.

### GitHub Actions shape

The existing `actions/setup-node@v4` step keeps these cache inputs:

```yaml
with:
  node-version: 22
  cache: npm
  cache-dependency-path: apps/documentation/package-lock.json
```

This action caches the npm shared cache. The CLI installation uses that
cache. After `npm run build` and all `workflow.build.after-site-build` steps,
the workflow emits these steps:

```yaml
- name: Install the Static Web Apps CLI
  run: npm install --global @azure/static-web-apps-cli@2.0.10
- name: Deploy to Azure Static Web Apps
  run: swa deploy ./build --deployment-token "$SWA_CLI_DEPLOYMENT_TOKEN" --env production
  env:
    SWA_CLI_DEPLOYMENT_TOKEN: ${{ secrets.<api-token-secret> }}
```

Both run steps inherit
`defaults.run.working-directory: apps/documentation`.

### Azure Pipelines shape

When the tool is `swa-cli`, the pipeline sets this variable:

```yaml
variables:
  npm_config_cache: $(Pipeline.Workspace)/.npm
```

After `NodeTool@0` and before `npm ci`, the pipeline restores this cache:

```yaml
- task: Cache@2
  displayName: Cache npm
  inputs:
    key: '"npm" | "$(Agent.OS)" | "swa-cli-2.0.10" | apps/documentation/package-lock.json'
    restoreKeys: |
      "npm" | "$(Agent.OS)" | "swa-cli-2.0.10"
      "npm" | "$(Agent.OS)"
    path: $(npm_config_cache)
```

The shared cache is in scope for this change. It supplies packages to both
`npm ci` and the CLI installation. The CLI version in the key gives a new
cache when the factory changes the pin.

After `npm run build` and all `workflow.build.after-site-build` steps, the
pipeline emits these steps:

```yaml
- script: npm install --global @azure/static-web-apps-cli@2.0.10
  displayName: Install the Static Web Apps CLI
  workingDirectory: apps/documentation
- script: swa deploy ./build --deployment-token "$SWA_CLI_DEPLOYMENT_TOKEN" --env production
  displayName: Deploy to Azure Static Web Apps
  workingDirectory: apps/documentation
  env:
    SWA_CLI_DEPLOYMENT_TOKEN: $(<api-token-secret>)
```

### Deployment and notification parity

The GitHub secret mapping stays
`${{ secrets.<api-token-secret> }}`. The Azure secret mapping stays
`$(<api-token-secret>)`, as `adr-azure-secret-mapping` specifies.

Each provider installs the CLI after a successful build. Each provider runs
the deploy command after a successful installation. A failed installation or
deployment stops later normal steps.

After a successful deployment, the existing notification step runs without
a change. It uses the configured site URL and the existing message,
provider, retry, and secret rules.

## Errors

- A CLI installation failure stops the pipeline before deployment.
- A missing or invalid deployment token fails the deploy step.
- A deploy failure stops the notification step.
- The pipeline does not write the deployment token to a log.
