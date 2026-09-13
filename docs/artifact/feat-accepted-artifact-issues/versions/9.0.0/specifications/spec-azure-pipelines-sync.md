# spec-azure-pipelines-sync: Azure Pipelines accepted artifact synchronization

**Master:** [Specifications](README.md)
**Covers:** req-azure-pipelines-sync, req-accepted-only, req-artifact-hierarchy, req-configurable-status, req-artifact-type-labels, req-support-trello-free, req-split-trello-boards, req-resolve-trello-board-id, req-multiple-accepted-artifact-providers, req-accepted-artifact-notification, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The Azure pipeline synchronizes accepted artifacts after an artifact pull
request merges. It gives the same result as the GitHub Actions workflow. It
reuses the same synchronizer, the same configuration, and the same notifier.

## Contract

The factory emits `azure-pipelines/accepted-artifact-issues.yml` only when the
project-issues composition is enabled and the CI provider is
`azure-pipelines`. It emits no GitHub workflow file for this selection. It
emits the shared scripts `.github/artifact-issues/sync.py` and
`.github/artifact-issues/notify.py`, the file
`.github/artifact-issues/config.json`, and the setup guides. The scripts and
the configuration are byte-identical to the GitHub Actions selection for the
same provider settings.

The pipeline runs on a pull request merge. It checks out the trusted merge
commit. It never runs content from an unmerged pull request. A manual run
scans the complete artifact tree for setup and recovery.

For each changed artifact, the synchronizer keeps the contract of
spec-sync-workflow:

1. Make each missing parent issue from the accepted tree.
2. Create or update the artifact issue.
3. Set the configured status for a new issue.
4. Keep the current status for an existing issue.
5. Change the issue identity when Git reports a rename.
6. Withdraw the issue when Git reports a deletion.
7. Add the issue URL to one managed pull request comment.

The manual run creates or updates every current artifact. It does not withdraw
an issue because the scan has no accepted deletion event.

The provider adapters, target settings, and status policy stay unchanged. The
Trello adapter works without Custom Fields. It routes plans and tasks to the
optional implementation board. It uses the resolved board ID for managed label
creation. Each new issue carries its artifact type label.

When acceptance notification is enabled, the synchronizer writes a result for
the changed artifact files. A following step sends one summary for an
automatic merged pull request. It sends the same plain-text summary to each
selected Google Chat, Slack, and Telegram provider. It sends no summary for a
manual scan or an empty result.

Each credential name maps one to one onto an Azure secret variable with the
same name. The names include the project provider secrets and the
notification webhook secrets. The Telegram chat ID stays a plain variable.

## Errors

- Stop before a write if the provider schema or credentials are not correct.
- Return success without writes when a merged pull request has no feature
  artifacts.
- Make no project issue when a pull request closes without merge.
- Make no duplicate issue on a repeated run.
- Keep a partial-write report in the pipeline log if an external API fails.
- Fail after all selected notification providers run when one or more
  providers fail.
