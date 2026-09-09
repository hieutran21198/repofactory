# spec-live-provider-e2e: Check the live providers

**Master:** [Specifications](README.md)
**Covers:** req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The end-to-end component deploys the generated integration to two test repositories. One
repository uses GitHub Projects. The other repository uses Trello.

The component creates provider resources during setup. It keeps the resources after a check. It
closes GitHub issues and archives Trello cards when cleanup is necessary.

## Command-line contract

The component has these commands:

- `setup` creates or checks the test repositories, the GitHub Project, and the Trello board.
- `test` checks one provider or both providers.
- `cleanup` removes test branches and closes or archives test items.

The `test` command accepts `--provider github-projects`, `--provider trello`, or `--provider all`.
The default value is `all`. The command checks the providers in sequence.

## Credential contract

The component reads these environment variables:

- `GH_TOKEN` contains a GitHub personal access token.
- `TRELLO_API_KEY` contains a Trello API key.
- `TRELLO_TOKEN` contains a Trello user token.

The component must not write a credential to a file or to the output. The setup command writes the
credentials to the applicable GitHub Actions secrets.

## Resource contract

The GitHub account is `hieutran21198`. The component uses these persistent resources:

- `repofactory-e2e-github-projects`, a private GitHub repository.
- `repofactory-e2e-trello`, a private GitHub repository.
- `Repofactory E2E – Accepted Artifacts`, a private personal GitHub Project.
- `Repofactory E2E – Accepted Artifacts`, a private Trello board.

The GitHub Project has one single-select field named `Status`. The field has the options
`Accepted`, `Ready`, and `Withdrawn`.

The Trello board has one open list for each status. It has the text fields `Artifact path`,
`Artifact type`, and `Parent artifact`.

## Check contract

The component uses one unique feature name for each check. It checks these events:

1. Close an artifact pull request without a merge.
2. Merge a pull request that has no artifact.
3. Merge a pull request that adds an artifact tree.
4. Run the same workflow again.
5. Start a manual full scan.
6. Change one artifact.
7. Rename one artifact.
8. Delete one artifact.
9. Delete the remaining artifact tree.

The component checks provider identity, status, hierarchy, links, and the managed pull request
comment. A second run must not make a duplicate provider item or a duplicate managed comment.

## Failures

The command stops with a nonzero exit status if a setup check or an assertion fails. It shows the
resource URLs and the failed step. It does not delete the provider resources after a failure.

The command waits a maximum of ten minutes for one workflow. It increases the delay between API
requests during the wait.
