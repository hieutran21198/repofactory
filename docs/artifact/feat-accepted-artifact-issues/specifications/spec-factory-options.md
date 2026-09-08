# spec-factory-options: Factory options and files

**Master:** [Specifications](README.md)
**Covers:** req-configurable-status, req-accepted-only
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The project-management domain supplies provider location, credential names, and artifact status
options. The artifact-driven composition emits the workflow, synchronizer, configuration, and
setup guide.

## Contract

```nix
factory.domain.project-management = {
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

  provider.github-projects = {
    ownership = "personal"; # or "organization"
    owner = "owner-name";
    project-number = 1;
    token-secret = "PROJECTS_TOKEN";
  };

  provider.trello = {
    board-id = "board-id";
    api-key-secret = "TRELLO_API_KEY";
    token-secret = "TRELLO_TOKEN";
  };
};
```

Emit these generated files only for the complete supported selection:

- `.github/workflows/accepted-artifact-issues.yml`
- `.github/artifact-issues/sync.py`
- `.github/artifact-issues/config.json`
- `docs/wiki/documentation/artifact-driven/project-issues.md`

## Errors

- Stop Nix evaluation when a selected provider has no required location value.
- Emit no integration files when the documentation model or CI provider does not match.
