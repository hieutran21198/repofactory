# task-ci-provider-option: Add the Azure Pipelines provider option

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-sync, spec-ci-cd-provider, spec-factory-options, spec-composition-options

## Goal

The domain accepts `azure-pipelines` as a CI provider value without a change to `github-actions`.

## Steps

1. Add `azure-pipelines` to the values of `factory.domain.ci-cd.provider.use`.
2. Keep `unset` as the default value.
3. Keep the `github-actions` settings unchanged.
4. Add an empty `azure-pipelines` provider branch that needs no extra settings.
5. Keep the rule that the CI selection does not enable the project-issues composition.

## Check

- Run `nix eval` on the provider option with `unset`, `github-actions`, and `azure-pipelines`.
- Show that Nix stops evaluation for another value.
- Show that `unset` emits no CI files.
- Show that `github-actions` keeps its result for the same settings.
