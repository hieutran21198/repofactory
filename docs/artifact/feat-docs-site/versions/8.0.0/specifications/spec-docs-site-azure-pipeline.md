# spec-docs-site-azure-pipeline: Publish the site on Azure Pipelines

**Master:** [Specifications](README.md)
**Covers:** req-azure-pipelines-publish, req-generated-assets, req-deployment-notification, req-multiple-deployment-providers, req-azure-static-web-app, req-docs-site-azure-pipelines-folder
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Renderer interface

The local Azure pipeline renderer takes the selected folder from its caller:

```nix
azurePipeline = folder: docsSite: <pipeline text>;
```

The docs-site composition sets `folder` to
`factory.domain.ci-cd.provider.azure-pipelines.folder`. The composition passes
the same value to the renderer and the generated file path.

The factory emits the rendered text at `${folder}/docs-site.yml`. The renderer
does not declare or validate the folder option. The Azure Pipelines provider
domain owns the option, its default, and its validation.

### Trigger

The pipeline starts on each push to the default branch. The push trigger
contains these paths first:

```yaml
- docs/**
- apps/documentation/**
- ${folder}/docs-site.yml
```

The renderer writes `workflow.watch-paths` after these paths and keeps the
configured order. The pipeline also supports a manual run for setup and
recovery. The trigger does not change per target.

For the same docs-site settings, a custom folder changes two values:

1. The emitted pipeline path becomes `${folder}/docs-site.yml`.
2. The trigger self-path becomes `${folder}/docs-site.yml`.

All other pipeline bytes are identical to the bytes for the default folder.
The default folder produces the version 7.0.0 pipeline bytes and path.

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

A custom run step inherits the job working directory `apps/documentation`
unless it sets `working-directory`. A step failure stops later steps and
prevents deployment.

### Extension-point mapping

The pipeline maps each typed step onto Azure syntax and keeps list order. The
mapping keeps these rules from the GitHub renderer:

- Each step keeps exactly one non-empty `uses` or `run` value.
- A `uses` step keeps its `name`, `with` inputs, and `env` values.
- A `run` step keeps its `name`, `env` values, and `working-directory`
  override.
- The renderer omits absent fields and empty maps.
- The renderer JSON-encodes each scalar value. Strings stay strings, Booleans
  stay Booleans, and numbers stay numbers in YAML.

Empty extension lists add no watch path and no build step. In this state, the
build behavior matches the GitHub Actions pipeline for the same target.

### Publication

With `target = "github-pages"`, the pipeline publishes the build output to
GitHub Pages without a manual step. The repository owner sets the Pages source
to "GitHub Actions" in the repository settings. The factory cannot do this
step, so the factory documents it as the one manual step.

The pipeline publishes with a GitHub token that the repository maintainer
stores as an Azure secret variable. The secret name is
`DOCS_SITE_GITHUB_TOKEN`. It maps one to one onto the Azure secret variable
with the same name. The pipeline needs this token only when the target is
`github-pages`.

With `target = "azure-static-web-app"`, the pipeline publishes
`apps/documentation/build` with task `AzureStaticWebApp@0`,
`app_location: apps/documentation/build`, `output_location: build`, and
`skip_app_build: true`. The token input reads `$(<api-token-secret>)`. The
pipeline emits no `gh-pages` publish step. The repository owner makes the
manual Azure steps in
[spec-azure-static-web-app](spec-azure-static-web-app.md).

With `skip_app_build: true`, the task ignores `output_location`. It reads the
app artifacts directly from `app_location`. The composition keeps
`output_location: build` only for shape compatibility.

### Notification reuse

When a notification provider is selected, the pipeline runs the same notifier
`.github/docs-site/notify.py` after a successful deployment to either target.
The notifier sends the same plain-text message to every selected provider. It
sends `{"text": "..."}` to webhook providers. It sends
`{"chat_id": "...", "text": "..."}` to Telegram Bot API `sendMessage`.

The pipeline maps each CI variable onto the notifier input. Each secret name
maps one to one onto an Azure secret variable with the same name. This rule
covers the Google Chat webhook secret, the Slack webhook secret, the Telegram
token secret, and the Static Web App token secret. The Telegram chat ID stays
a plain variable.

With `azure-static-web-app`, the deployment URL input uses the configured site
URL. The retry and failure rules in
[spec-multiple-deployment-providers](spec-multiple-deployment-providers.md)
still apply.

When no provider is selected, the composition adds no notifier and no
notification step.

## Description

The generated Azure pipeline builds the website and publishes it to the
selected target. It gives the same result as the GitHub Actions workflow for
the same target.

The pipeline uses the selected Azure Pipelines folder in its file path and
trigger self-path. It reuses the same site project, typed extension values,
pinned tooling, and notifier. The target contract is in
[spec-azure-static-web-app](spec-azure-static-web-app.md).

## Errors

- Stop Nix evaluation before file emission when the Azure Pipelines folder is
  empty or invalid.
- Emit no pipeline file after an Azure Pipelines folder error.
- Stop Nix evaluation for an invalid typed value or an invalid step relation.
- Stop Nix evaluation for an invalid target or an invalid token secret name.
- Stop the build before deployment when a custom step exits with a nonzero
  status.
- Stop notification delivery for an unsupported provider or a missing message
  value.
- Report the response status without the webhook URL, the bot token, the
  deployment token, or the response body.
