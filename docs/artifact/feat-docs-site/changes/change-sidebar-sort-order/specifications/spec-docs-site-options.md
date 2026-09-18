# spec-docs-site-options: Declare the docs-site composition options

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-generated-assets, req-azure-static-web-app, req-sidebar-feature-order-option
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Activation

The docs-site composition is enabled only when all these conditions hold:

- `factory.composition.artifact-driven.docs-site.enable` is `true`.
- `factory.domain.documentation.use` is `"artifact-driven"`.
- `factory.domain.repo-arch.use` is `"multiple"`.
- `factory.domain.ci-cd.provider.use` is `"github-actions"` or `"azure-pipelines"`.

A project that selects `github-actions` with `target = "github-pages"` keeps the version 5.0.0
behavior. A project that selects `azure-pipelines` gets the same site project and typed extension
values. [spec-docs-site-azure-pipeline](spec-docs-site-azure-pipeline.md) defines that pipeline.
[spec-azure-static-web-app](spec-azure-static-web-app.md) defines the target contract.

### Site, sidebar, and pipeline options

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `enable` | `bool` | `false` | Render the site and one CI pipeline. |
| `title` | `str` | `"Documentation"` | Set the browser and navbar title. |
| `url` | `str` | `""` | Set the website origin. |
| `base-url` | `str` | `"/"` | Set the website path below its origin. |
| `target` | `enum [ "github-pages", "azure-static-web-app" ]` | `"github-pages"` | Select the hosting service for the site. |
| `azure-static-web-app.api-token-secret` | `str` | `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"` | Name the secret that holds the Static Web App deployment token. |
| `static-directories` | `listOf str` | `[]` | Set Docusaurus static directories relative to `apps/documentation/`. |
| `sidebar.feature-order` | `listOf str` | `[]` | Set feature folder basenames in sidebar order. |
| `workflow.watch-paths` | `listOf str` | `[]` | Add paths to the push trigger after the factory paths. |
| `workflow.build.before-node-setup` | `listOf workflowStep` | `[]` | Add steps after checkout and before Node.js setup. |
| `workflow.build.before-site-build` | `listOf workflowStep` | `[]` | Add steps after dependency installation and before the site build. |
| `workflow.build.after-site-build` | `listOf workflowStep` | `[]` | Add steps after the site build and before artifact upload. |

Each `sidebar.feature-order` value is a complete folder basename, such as `feat-docs-site`.
Matching is case-sensitive. A listed feature folder uses its list position. An unlisted feature
folder follows all listed feature folders and uses alphabetical display-label order.

An empty `sidebar.feature-order` list keeps alphabetical feature order. The `workflow` option
group keeps its name on both CI providers and publication targets. The notification option tree
and its defaults do not change.

This repository sets its list in the tracked root `devenv.nix` module. It does not set the value
in `devenv.local.nix` because that file is not tracked.

### Workflow step type

| Field | Type | Default | Rule |
| --- | --- | --- | --- |
| `name` | optional `str` | absent | Set the displayed step name. |
| `uses` | optional `str` | absent | Select one action. It cannot occur with `run`. |
| `with` | `attrsOf workflowScalar` | `{}` | Set action inputs. It needs `uses`. |
| `run` | optional `str` | absent | Run one command or script. It cannot occur with `uses`. |
| `env` | `attrsOf workflowScalar` | `{}` | Set environment variables for the step. |
| `working-directory` | optional `str` | absent | Override the job default for a run step. It needs `run`. |

Nix configurations write the `with` field as `"with"` because `with` is a Nix keyword.

`workflowScalar` is `oneOf [ str bool int float ]`. Each renderer uses `builtins.toJSON` for each
value. Thus, values keep their scalar types in YAML.

The four optional string options use `nullable = true` and `default = null`. Each renderer omits
a field when its value is null. The validator checks a string only when its value is not null.
Each renderer omits empty maps and keeps list order.

### Assertions

The module applies these assertions when the site is enabled:

- The CI provider is `github-actions` or `azure-pipelines`.
- Each static directory and workflow watch path is not an empty string.
- Each `sidebar.feature-order` value is not an empty string.
- The `sidebar.feature-order` list has no duplicate string.
- Each pipeline step has exactly one non-empty `uses` or `run` value.
- A non-empty `with` map occurs only on a `uses` step.
- `working-directory` occurs only on a `run` step and is not empty.
- `target` is `github-pages` or `azure-static-web-app`.
- For the `azure-static-web-app` target, the token secret name matches
  `[A-Za-z_][A-Za-z0-9_]*`.

The uniqueness assertion compares the complete strings. All hook lists use the same assertions
on both CI providers and publication targets. Each error message names the docs-site option and
the invalid rule.

The evaluation test builder supplies `sidebar.feature-order` to each enabled test module. It
checks the empty default, a selected list, an empty value, a duplicate value, and the declared
`listOf str` shape. It does not exercise module-system wrong-type rejection.

## Description

The composition sub-module declares `factory.composition.artifact-driven.docs-site`. The option
is off by default. When it is on, the module checks the selected domains, site values, sidebar
values, target values, notification values, and pipeline step shapes.

The module accepts the CI provider `github-actions` or `azure-pipelines`. Both providers share one
typed step type and the same three build hooks. Both providers support both publication targets.

The module declares one private `workflowStepModule`. Each list option uses
`lib.types.submodule workflowStepModule` as its element type. Both pipeline renderers read the
same typed values. The existing builders in `factory._utils` are sufficient.

## Errors

The Nix module system rejects a feature-order value or another option with the wrong type. An
assertion stops evaluation for an empty or duplicate feature-order value when the site is enabled.
An assertion also stops evaluation for each invalid existing option relation. When `enable` is
`false`, the module emits no file and applies no docs-site assertion.
