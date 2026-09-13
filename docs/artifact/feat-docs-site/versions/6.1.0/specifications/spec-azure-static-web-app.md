# spec-azure-static-web-app: Publish the website to the selected target

**Master:** [Specifications](README.md)
**Covers:** req-azure-static-web-app
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The docs-site composition selects exactly one publication target. The target
is `github-pages` or `azure-static-web-app`. The default is `github-pages`.
Both CI providers support both targets. The Docusaurus output under
`apps/documentation/build` stays the source on both targets. The site
project, the typed extension points, the pinned tooling, and the
notifications work the same on both targets.

This specification owns the target option contract, the per-target publish
rule, the Static Web App deploy mechanics, the secret mapping, and the
manual Azure steps. The per-CI renderers in
[spec-docs-site-workflow](spec-docs-site-workflow.md) and
[spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) apply this
contract. The message and delivery rules in
[spec-multiple-deployment-providers](spec-multiple-deployment-providers.md)
still apply.

## Contract

### Target option

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `target` | `enum [ "github-pages", "azure-static-web-app" ]` | `"github-pages"` | Select the hosting service for the site. |
| `azure-static-web-app.api-token-secret` | `str` | `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"` | Name the secret that holds the Static Web App deployment token. |

The full option paths are
`factory.composition.artifact-driven.docs-site.target` and
`factory.composition.artifact-driven.docs-site.azure-static-web-app.api-token-secret`.
The module declares `target` with `lib.types.enum`. The token secret option
uses the same string builder as the notification secrets.

The composition selects exactly one target for one site. It does not accept
a list of targets. It does not accept an empty target.

### Per-CI publish behavior

Each generated pipeline builds the website and publishes it to the selected
target on each push to the default branch:

| CI provider | Generated file | Target `github-pages` | Target `azure-static-web-app` |
| --- | --- | --- | --- |
| `github-actions` | `.github/workflows/docs-site.yml` | Build job plus Pages deploy job. | Build job plus Static Web App deploy step. No Pages job. |
| `azure-pipelines` | `azure-pipelines/docs-site.yml` | Build steps plus `gh-pages` publish. | Build steps plus Static Web App task. No `gh-pages` publish. |

The build part does not change per target. It keeps Node.js 22, `npm ci`,
`npm run build`, the three typed build hooks in list order, and the
configured watch paths. The publish source stays `apps/documentation/build`
on both targets. A target selection never changes `site.json`, the
Docusaurus configuration, or the pinned packages.

With `target = "github-pages"`, the generated pipeline keeps the version
5.0.0 publish shape. The composition
emits no GitHub Pages publish content when the target is
`azure-static-web-app`. It emits no Static Web App content when the target
is `github-pages`.

### Static Web App deploy mechanics

The factory builds the site with `npm run build`. The deploy step only
uploads the result. It never builds the site a second time.

With `skip_app_build: true`, the Static Web App mechanisms ignore
`output_location`. They read the app artifacts directly from
`app_location`. Thus `app_location` is `apps/documentation/build`. The
composition keeps `output_location: build` only for shape-compatibility. A
real Azure deployment proved this rule. It failed when `app_location` was
`apps/documentation` with the message "Failed to find a default file in
the app artifacts folder".

On `github-actions`, the workflow deploys with
`Azure/static-web-apps-deploy@v1` and these inputs:

| Input | Value |
| --- | --- |
| `azure_static_web_apps_api_token` | `${{ secrets.<api-token-secret> }}` |
| `app_location` | `apps/documentation/build` |
| `output_location` | `build` |
| `skip_app_build` | `true` |

The workflow needs no `pages: write` permission and no `github-pages`
environment when the target is `azure-static-web-app`. The deploy step runs
after `npm run build` and after `workflow.build.after-site-build`.

On `azure-pipelines`, the pipeline deploys with `AzureStaticWebApp@0` and
these inputs:

| Input | Value |
| --- | --- |
| `app_location` | `apps/documentation/build` |
| `output_location` | `build` |
| `skip_app_build` | `true` |
| `azure_static_web_apps_api_token` | `$(<api-token-secret>)` |

The task runs after `npm run build` and after
`workflow.build.after-site-build`. A step failure stops later steps and
prevents deployment on both providers.

### Secret and variable mapping

The Static Web App deployment token is a secret on both CI providers:

- On `github-actions`, the workflow reads it from
  `${{ secrets.<api-token-secret> }}`. The default name is
  `DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN`.
- On `azure-pipelines`, the pipeline reads it from the secret variable
  `$(<api-token-secret>)`. Each secret name maps one to one onto an Azure
  secret variable with the same name.

The token secret is per-target. The composition needs it only when `target`
is `azure-static-web-app`. The GitHub Pages token `DOCS_SITE_GITHUB_TOKEN`
is needed only when the provider is `azure-pipelines` and the target is
`github-pages`. The notification secret names do not change. The Telegram
chat ID stays a plain variable.

### Notification reuse

A successful Static Web App deployment sends the same deployment message as
a GitHub Pages deployment. The notifier path, the message format, the
provider selection in `notification.uses`, and the retry rules do not
change. The notification step runs after the Static Web App deploy step and
only after a successful deployment.

The deployment URL input differs per target:

- With `github-pages` on `github-actions`, it uses the Pages output URL.
- With `azure-static-web-app` on either provider, it uses the configured
  site URL (`docsSite.url` plus `docsSite.base-url`).
- With `github-pages` on `azure-pipelines`, it keeps the configured site
  URL as in version 5.0.0.

### Manual Azure steps

The repository owner makes these preparations outside the factory:

1. Create one Static Web App resource in Azure for the site.
2. Copy the deployment token of that resource.
3. Store the token as a GitHub secret or an Azure secret variable with the
   configured secret name. Mark the Azure variable as secret.
4. Set the docs-site `url` and `base-url` options to the Static Web App
   address.

The factory cannot create the resource and cannot read the token. The user
guide documents these four steps.

## Errors

- Stop Nix evaluation when `target` is not `github-pages` or
  `azure-static-web-app`. The message names both supported targets.
- Stop Nix evaluation when the target is `azure-static-web-app` and the
  configured token secret name is not a valid secret name. A valid name
  matches `[A-Za-z_][A-Za-z0-9_]*`.
- Stop the pipeline before deployment when a custom build step exits with a
  nonzero status.
- Fail the deploy step when the deployment token is missing or invalid. Do
  not print the token value in any log.
