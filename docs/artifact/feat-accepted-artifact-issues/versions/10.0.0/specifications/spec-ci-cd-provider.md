# spec-ci-cd-provider: CI provider and Azure Pipelines folder options

**Master:** [Specifications](README.md)
**Covers:** req-azure-pipelines-sync, req-azure-pipelines-folder
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The CI provider option selects the CI system of a generated repository. The
Azure Pipelines provider has an option that selects its repository folder.
The values `unset` and `github-actions` keep their meaning.

## Contract

```nix
factory.domain.ci-cd.provider = {
  use = "azure-pipelines"; # or "unset", or "github-actions"
  azure-pipelines.folder = "azure-pipelines";
};
```

The `use` option accepts `unset`, `github-actions`, and `azure-pipelines`. Its
default is `unset`. The `folder` option is a string. Its default is
`azure-pipelines`.

A valid `folder` value is a non-empty relative POSIX repository path. It uses
`/` between path segments. It does not start with `/`. Each path segment is
non-empty and is not `.` or `..`. The value does not contain a backslash.

The factory validates `folder` for all CI provider selections. A valid custom
value has no effect unless a composition emits an Azure pipeline. The CI
selection does not enable the project-issues composition.

## Errors

- Stop Nix evaluation if `use` is not `unset`, `github-actions`, or
  `azure-pipelines`.
- Stop Nix evaluation if `folder` is empty.
- Stop Nix evaluation if `folder` starts with `/`.
- Stop Nix evaluation if a folder segment is empty, `.`, or `..`.
- Stop Nix evaluation if `folder` contains a backslash.
- Name the option and the failed rule in each folder error.
- Emit no blueprint files after an option error.
- Emit no CI files when `use` is `unset`.
