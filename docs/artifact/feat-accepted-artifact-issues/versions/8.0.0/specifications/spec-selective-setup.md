# spec-selective-setup: Set up selected providers

**Master:** [Specifications](README.md)
**Covers:** req-select-provider
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Command-line contract

The `setup` command accepts the `--provider` option. Its values are `github-projects`, `trello`,
and `all`. The default value is `all`.

## Credential contract

All setup selections need `GH_TOKEN` because each provider uses a GitHub repository. The
`github-projects` selection does not need Trello credentials. The `trello` selection also needs
`TRELLO_API_KEY` and `TRELLO_TOKEN`.

## Resource contract

Setup creates or checks the GitHub repositories for the selected providers. It creates or checks
the GitHub Project only for the `github-projects` selection. It creates or checks the Trello board
only for the `trello` selection.

## State contract

The state file can contain resources for one provider or both providers. Setup reads the current
state file and adds the selected resources. It keeps resources for providers that it does not
select.

The test and cleanup commands stop with an error if the state does not contain the selected
provider resources.

## Check contract

Unit checks cover the provider selector, credential selection, state merge, and partial-state
rendering. Existing rendering checks continue to cover both providers.
