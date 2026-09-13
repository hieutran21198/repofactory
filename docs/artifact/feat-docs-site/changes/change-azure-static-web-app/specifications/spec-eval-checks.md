# spec-eval-checks: Check typed docs-site extensions

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish, req-azure-static-web-app
**Context:** context-factory

## Description

The standalone Nix evaluation imports the docs-site module with a stub library. It checks the
generated files, option metadata, pipeline variants, targets, notifications, and assertions on both CI
providers. Python tests continue to check notifier behavior.

## Contract

The evaluation adds an `extensions` configuration. It uses two static directories, one watch path,
an action step before Node.js setup, a run step before the site build, and a run step after the site
build. Together, the steps use all six supported fields.

The evaluation checks these results:

- All five extension option defaults are empty lists.
- The `target` default is `"github-pages"`.
- The token secret default is `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"`.
- Each hook uses the same workflow step submodule.
- The step submodule declares the six fields with their specified types and defaults.
- Default `site.json` contains `staticDirectories = []`.
- Extended `site.json` keeps static directory order.
- The Docusaurus configuration reads `site.staticDirectories`.
- The extended watch path follows the three factory paths.
- Each custom step occurs at its specified point and list order is stable.
- YAML output contains the configured `name`, `uses`, `with`, `run`, `env`, and
  `working-directory` values.
- Empty extension lists add no custom pipeline content.
- Invalid paths and invalid step relations produce false assertions.
- An invalid target produces a false assertion with a message that names both targets.
- An invalid token secret name with the Static Web App target produces a false assertion.
- Existing file, dependency, notification, disabled-state, and domain-selection checks still pass.

The evaluation checks these Azure results:

- The `azure-pipelines` selection emits `azure-pipelines/docs-site.yml` and emits no GitHub
  workflow file.
- The `github-actions` selection emits `.github/workflows/docs-site.yml` and emits no Azure
  pipeline file.
- The Azure trigger lists the three factory paths first and then the configured watch path.
- Each typed build step occurs at its specified point in the Azure pipeline in list order.
- The Azure pipeline keeps the same `site.json` bytes as the GitHub selection.
- The Azure notifier path and its bytes match the GitHub selection.
- A docs-site composition with a CI provider other than `github-actions` or `azure-pipelines`
  produces a false assertion.

The evaluation checks these target results on both CI providers:

- With the default target, the pipeline publishes to GitHub Pages and emits no Static Web App
  content.
- With `azure-static-web-app`, the pipeline publishes `apps/documentation/build` with the Static
  Web App deploy action or task, `skip_app_build: true`, and the configured token secret. It emits
  no GitHub Pages publish content.
- With `azure-static-web-app`, the notification step still runs after a successful deployment with
  the same notifier and the same providers.
- Extension steps keep their points and order on the Static Web App target.
- `site.json` bytes are identical on both targets for the same site values.

The test stub adds the minimum `types`, `mkAttrsOpt`, string concatenation, and attribute helpers
that the production module uses. It does not duplicate the Nix module system.

## Commands

Run the module evaluation:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix
```

Run the notifier regression tests:

```sh
python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py
```

Build the self-hosted website with Node.js 22 after the evaluation passes.

## Errors

The Nix command stops if a Boolean check is false or a source file is absent. The Python command
reports each failed notifier test and exits with a nonzero status.
