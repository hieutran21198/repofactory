# spec-eval-checks: Check typed docs-site extensions

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets, req-azure-pipelines-publish, req-azure-static-web-app, req-docs-site-azure-pipelines-folder
**Context:** context-factory

## Contract

The standalone Nix evaluation imports the docs-site module with a stub
library. Its configuration fixture supplies
`factory.domain.ci-cd.provider.azure-pipelines.folder`. The fixture default is
`azure-pipelines`.

### Folder checks

The evaluation checks these folder results:

- The default Azure selection emits `azure-pipelines/docs-site.yml`.
- The default Azure trigger includes `azure-pipelines/docs-site.yml`.
- The folder `ci/azure` emits `ci/azure/docs-site.yml`.
- The custom-folder trigger includes `ci/azure/docs-site.yml`.
- The custom selection emits no pipeline at
  `azure-pipelines/docs-site.yml`.
- After normalization of the trigger self-path, the default and custom
  pipeline contents are byte-identical.
- A custom folder with the `github-actions` selection does not change a path
  or file.
- The GitHub Actions workflow stays at `.github/workflows/docs-site.yml`.
- The GitHub Actions selection emits no Azure pipeline file.

The integration evaluation checks the existing Azure Pipelines provider
validation. It rejects these folder values before file emission:

- An empty value.
- An absolute value such as `/absolute`.
- A value with an empty segment, such as `ci//azure`.
- A value with a `.` segment, such as `ci/./azure`.
- A value with a `..` segment, such as `ci/../azure`.
- A value with a backslash, such as `ci\azure`.

Each folder error names
`factory.domain.ci-cd.provider.azure-pipelines.folder` and the failed rule. The
docs-site composition adds no folder assertion.

### Existing docs-site checks

The evaluation adds an `extensions` configuration. It uses two static
directories, one watch path, and three build steps. Together, the steps use all
six supported fields.

The evaluation checks these results:

- All five extension option defaults are empty lists.
- The `target` default is `"github-pages"`.
- The token secret default is
  `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"`.
- Each hook uses the same workflow step submodule.
- The step submodule declares the six fields with their specified types and
  defaults.
- Default `site.json` contains `staticDirectories = []`.
- Extended `site.json` keeps static directory order.
- The Docusaurus configuration reads `site.staticDirectories`.
- The extended watch path follows the three factory paths.
- Each custom step occurs at its specified point and list order is stable.
- YAML output contains the configured `name`, `uses`, `with`, `run`, `env`,
  and `working-directory` values.
- Empty extension lists add no custom pipeline content.
- Invalid paths and invalid step relations produce false assertions.
- An invalid target produces a false assertion with a message that names both
  targets.
- An invalid token secret name with the Static Web App target produces a false
  assertion.
- Existing file, dependency, notification, disabled-state, and
  domain-selection checks still pass.

The evaluation checks these Azure results:

- The `azure-pipelines` selection emits the selected Azure pipeline and emits
  no GitHub workflow file.
- The `github-actions` selection emits `.github/workflows/docs-site.yml` and
  emits no Azure pipeline file.
- The Azure trigger lists the three factory paths first and then the configured
  watch path.
- Each typed build step occurs at its specified point in the Azure pipeline in
  list order.
- The Azure pipeline keeps the same `site.json` bytes as the GitHub selection.
- The Azure notifier path and its bytes match the GitHub selection.
- A docs-site composition with an unsupported CI provider produces a false
  assertion.

The evaluation checks these target results on both CI providers:

- With the default target, the pipeline publishes to GitHub Pages and emits no
  Static Web App content.
- With `azure-static-web-app`, the pipeline publishes
  `apps/documentation/build` with the Static Web App deploy action or task,
  `skip_app_build: true`, and the configured token secret. It emits no GitHub
  Pages publish content.
- With `azure-static-web-app`, the notification step still runs after a
  successful deployment with the same notifier and providers.
- Extension steps keep their points and order on the Static Web App target.
- `site.json` bytes are identical on both targets for the same site values.

The test stub adds the minimum `types`, `mkAttrsOpt`, string concatenation, and
attribute helpers that the production module uses. It does not duplicate the
Nix module system.

## Description

The evaluations check the generated files, option metadata, pipeline variants,
targets, notifications, and assertions on both CI providers. They also check
the Azure Pipelines folder contract. Python tests continue to check notifier
behavior.

## Commands

Run the docs-site module evaluation:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix
```

Run the artifact-driven composition evaluation:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix
```

Run the notifier regression tests:

```sh
python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py
```

Build the self-hosted website with Node.js 22 after the evaluations pass.

## Errors

Each Nix command stops if a Boolean check is false or a source file is absent.
The Python command reports each failed notifier test and exits with a nonzero
status.
