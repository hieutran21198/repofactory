# spec-factory-options: Factory options and files

**Master:** [Specifications](README.md)
**Covers:** req-configurable-status, req-accepted-only
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The project-management domain selects an adapter. Each adapter supplies its location and
credential-name options. The artifact-driven project-issues composition owns its activation and
artifact status policy. It emits the workflow, synchronizer, configuration, and setup guide.

## Contract

```nix
factory = {
  domain = {
    documentation.use = "artifact-driven";
    ci-cd.provider.use = "github-actions";
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

`project-issues.enable` defaults to `false`. Selecting adapters does not enable this composition.
Emit these generated files only when the composition is enabled:

- `.github/workflows/accepted-artifact-issues.yml`
- `.github/artifact-issues/sync.py`
- `.github/artifact-issues/config.json`
- `docs/wiki/documentation/artifact-driven/project-issues.md`

## Errors

- When enabled, stop Nix evaluation if the documentation model, CI provider, or project provider
  is not supported.
- When enabled, stop Nix evaluation when a status is empty or the selected adapter settings are
  not valid.
- When disabled, emit no integration files and do not apply composition preconditions.
