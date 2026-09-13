# spec-ci-cd-provider: CI provider option with Azure Pipelines

**Master:** [Specifications](README.md)
**Covers:** req-azure-pipelines-sync
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The CI provider option selects the CI system of a generated repository. This
change adds `azure-pipelines` to the option. The values `unset` and
`github-actions` keep their meaning.

## Contract

```nix
factory.domain.ci-cd.provider = {
  use = "azure-pipelines"; # or "unset", or "github-actions"
};
```

The option accepts `unset`, `github-actions`, and `azure-pipelines`. The
default is `unset`. The `github-actions` settings stay unchanged. The
`azure-pipelines` selection needs no extra provider settings.

The CI selection does not enable the project-issues composition. The
composition reads the CI selection only when it is enabled.

## Errors

- Stop Nix evaluation when `use` has another value than `unset`,
  `github-actions`, or `azure-pipelines`.
- Emit no CI files when `use` is `unset`.
