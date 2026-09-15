# spec-factory-options: Factory options and files

**Master:** [Specifications](README.md)
**Covers:** req-configurable-status, req-accepted-only, req-azure-pipelines-folder
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The project-management domain selects an adapter. Each adapter supplies its
location and credential-name options. The CI provider domain owns the Azure
Pipelines folder option. The artifact-driven project-issues composition owns
its activation and artifact status policy. It emits the CI files,
synchronizer, configuration, and setup guide.

## Contract

```nix
factory = {
  domain = {
    documentation.use = "artifact-driven";
    ci-cd.provider = {
      use = "azure-pipelines"; # or "github-actions"
      azure-pipelines.folder = "ci/azure";
    };
    project-management.provider = {
      use = "github-projects";
      github-projects = {
        ownership = "personal"; # or "organization"
        owner = "owner-name";
        project-number = 1;
        token-secret = "PROJECTS_TOKEN";
      };
    };
  };

  composition.artifact-driven.project-issues = {
    enable = true;
    artifact-status = {
      feature-summary = "Accepted";
      master-requirement = "Accepted";
      requirement = "Accepted";
      master-specification = "Accepted";
      specification = "Accepted";
      decision = "Accepted";
      implementation-plan = "Accepted";
      task = "Ready";
      change-summary = "Accepted";
      withdrawn = "Withdrawn";
    };
  };
};
```

`project-issues.enable` defaults to `false`. A provider selection does not
enable this composition. The factory emits integration files only when the
composition is enabled. The CI file depends on the selected CI provider:

- `github-actions` emits `.github/workflows/accepted-artifact-issues.yml`.
- `azure-pipelines` emits `<folder>/accepted-artifact-issues.yml`.
- The default `<folder>` is `azure-pipelines`.

Both selections emit the shared synchronizer, notifier, configuration, and
setup guides:

- `.github/artifact-issues/sync.py`
- `.github/artifact-issues/config.json`
- `docs/wiki/documentation/artifact-driven/project-issues.md`

## Errors

- When enabled, stop Nix evaluation if the documentation model is not
  supported.
- When enabled, stop Nix evaluation if the CI provider is not supported.
- When enabled, stop Nix evaluation if the project provider is not supported.
- Stop Nix evaluation when the Azure Pipelines folder violates
  `spec-ci-cd-provider`.
- When enabled, stop Nix evaluation when a status is empty.
- When enabled, stop Nix evaluation when selected adapter settings are not
  valid.
- When disabled, emit no integration files.
- When disabled, do not apply composition preconditions.
