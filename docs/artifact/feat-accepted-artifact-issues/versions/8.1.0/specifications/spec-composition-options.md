# spec-composition-options: Define the project-issues composition options

**Master:** [Specifications](README.md)
**Covers:** req-configurable-status, req-accepted-only
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The artifact-driven project-issues composition owns its activation and artifact lifecycle policy.
The project-management provider selects an adapter and owns the target and credential settings of
that adapter. This specification replaces the option ownership and activation contract in
`spec-factory-options`.

## Contract

```nix
factory = {
  domain = {
    documentation.use = "artifact-driven";
    ci-cd.provider.use = "github-actions";

    project-management.provider = {
      use = "github-projects";
      github-projects = {
        ownership = "personal";
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

`project-issues.enable` defaults to `false`. The artifact status defaults stay as shown in the
example. The old `factory.domain.project-management.artifact-status` option does not exist.

Selecting a provider does not enable the composition. When the composition is disabled, it emits
no project-issue integration files and does not require complete provider settings.

When the composition is enabled, it emits the workflow, synchronizer, provider configuration, and
setup guide. The provider configuration gets statuses from the composition and target values from
the selected provider adapter.

## Errors

When `project-issues.enable` is true, stop Nix evaluation if:

- the documentation model is not `artifact-driven`;
- the CI provider is not `github-actions`;
- the project-management provider is not `github-projects` or `trello`;
- a status is empty;
- the selected provider target is incomplete; or
- a configured GitHub Actions secret name is not valid.

Do not apply these composition preconditions when `project-issues.enable` is false.
