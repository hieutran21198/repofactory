# spec-docs-site-azure-pipeline: Publish the site on Azure Pipelines

**Master:** [Specifications](README.md)
**Covers:** req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The generated Azure pipeline builds the website and publishes it to the selected target. It gives the
same result as the GitHub Actions workflow for the same target. It reuses the same site project, the same typed
extension values, the same pinned tooling, and the same notifier. Only the pipeline file and the
variable mapping change per target. The target contract is in
[spec-azure-static-web-app](spec-azure-static-web-app.md).

## Contract

### Trigger

The pipeline starts on each push to the default branch. The push trigger contains these paths
first:

```yaml
- docs/**
- apps/documentation/**
- azure-pipelines/docs-site.yml
```

The renderer writes `workflow.watch-paths` after these paths and keeps the configured order. The
pipeline also supports a manual run for setup and recovery. The trigger does not change per target.

### Build step order

The build job uses this order on both targets:

1. Check out the repository.
2. Run `workflow.build.before-node-setup` in list order.
3. Set up Node.js 22.
4. Run `npm ci` in `apps/documentation`.
5. Run `workflow.build.before-site-build` in list order.
6. Run `npm run build` in `apps/documentation`.
7. Run `workflow.build.after-site-build` in list order.
8. Publish `apps/documentation/build` to the selected target.

A custom run step inherits the job working directory `apps/documentation` unless it sets
`working-directory`. A step failure stops later steps and prevents deployment.

### Extension-point mapping

The pipeline maps each typed step onto Azure syntax and keeps list order. The mapping keeps these
rules from the GitHub renderer:

- Each step keeps exactly one non-empty `uses` or `run` value.
- A `uses` step keeps its `name`, `with` inputs, and `env` values.
- A `run` step keeps its `name`, `env` values, and `working-directory` override.
- The renderer omits absent fields and empty maps.
- The renderer JSON-encodes each scalar value, so strings stay strings, Booleans stay Booleans,
  and numbers stay numbers in YAML.

Empty extension lists add no watch path and no build step. In this state, the build behavior matches the GitHub Actions pipeline for the same target.

### Publication

With `target = "github-pages"`, the pipeline publishes the build output to GitHub Pages without a manual step. The repository
owner sets the Pages source to "GitHub Actions" in the repository settings. The factory cannot do
this step, so the factory documents it as the one manual step.

The pipeline publishes with a GitHub token that the repository maintainer stores as an Azure
secret variable. The secret name is `DOCS_SITE_GITHUB_TOKEN`. It maps one to one onto the Azure
secret variable with the same name. The pipeline needs this token only when the target is
`github-pages`.

With `target = "azure-static-web-app"`, the pipeline publishes `apps/documentation/build` with
task `AzureStaticWebApp@0`, `app_location: apps/documentation`, `output_location: build`, and
`skip_app_build: true`. The token input reads `$(<api-token-secret>)`. The pipeline emits no
`gh-pages` publish step. The repository owner makes the manual Azure steps in
[spec-azure-static-web-app](spec-azure-static-web-app.md).

### Notification reuse

When a notification provider is selected, the pipeline runs the same notifier
`.github/docs-site/notify.py` after a successful deployment to either target. The notifier sends the same
plain-text message to every selected provider. It sends `{"text": "..."}` to webhook providers. It
sends `{"chat_id": "...", "text": "..."}` to Telegram Bot API `sendMessage`.

The pipeline maps each CI variable onto the notifier input. Each secret name maps one to one onto
an Azure secret variable with the same name. This rule covers the Google Chat webhook secret, the
Slack webhook secret, the Telegram token secret, and the Static Web App token secret. The Telegram chat ID stays a plain variable.
With `azure-static-web-app`, the deployment URL input uses the configured site URL. The retry and
failure rules in [spec-multiple-deployment-providers](spec-multiple-deployment-providers.md) still apply.

When no provider is selected, the composition adds no notifier and no notification step.

## Errors

- Stop Nix evaluation for an invalid typed value or an invalid step relation.
- Stop Nix evaluation for an invalid target or an invalid token secret name.
- Stop the build before deployment when a custom step exits with a nonzero status.
- Stop notification delivery for an unsupported provider or a missing message value.
- Report the response status without the webhook URL, the bot token, the deployment token, or the response body.
