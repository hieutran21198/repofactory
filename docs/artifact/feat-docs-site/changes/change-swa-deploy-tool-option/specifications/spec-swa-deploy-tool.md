# spec-swa-deploy-tool: Select the Static Web App deploy tool

**Master:** [Specifications](README.md)
**Covers:** req-swa-deploy-tool
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The docs-site composition gives one deploy tool to a site that uses the
`azure-static-web-app` target. The factory applies the selection to GitHub
Actions and Azure Pipelines.

This specification extends the option tables in `spec-docs-site-options` and
`spec-azure-static-web-app`. It partially supersedes the official-task-only
clauses in `spec-azure-static-web-app`, `spec-docs-site-workflow`,
`spec-docs-site-azure-pipeline`, and `spec-eval-checks`. Those clauses apply
when the deploy tool is `official-task`. The CLI clauses are in
[spec-swa-cli-deploy](spec-swa-cli-deploy.md).

## Contract

The composition declares this option:

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `azure-static-web-app.deploy-tool` | `lib.types.enum [ "official-task" "swa-cli" ]` | `"official-task"` | Select the mechanism that uploads a Static Web App. |

The full option path is
`factory.composition.artifact-driven.docs-site.azure-static-web-app.deploy-tool`.
The project configuration does not contain a CLI version option.

For one site with the `azure-static-web-app` target, the scalar enum selects
exactly one deploy tool:

- `official-task` emits only the version 6.1.0 official deploy action or task.
- `swa-cli` emits only the CLI install step and the CLI deploy step.

The factory applies the same selection to GitHub Actions and Azure Pipelines.
The selection does not change the build output, token secret name, hooks,
extension points, or notification contract.

For the `github-pages` target, the option does not change the pipeline. The
pipeline emits no Static Web App action, task, CLI install step, or CLI deploy
step.

## Errors

An unsupported deploy tool stops Nix evaluation. The error message names the
full option path and both supported tools:

```text
factory.composition.artifact-driven.docs-site.azure-static-web-app.deploy-tool must be "official-task" or "swa-cli"
```
