# task-azure-pipeline-emission: Emit the Azure pipeline with the shared synchronizer

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-sync, spec-azure-pipelines-sync, spec-factory-options, spec-composition-options, adr-shared-sync-implementation, adr-azure-secret-mapping

## Goal

The composition emits one Azure pipeline that gives the same result as GitHub Actions.

## Steps

1. Emit `azure-pipelines/accepted-artifact-issues.yml` only when the project-issues composition is enabled and the CI provider is `azure-pipelines`.
2. Emit no GitHub workflow file for the `azure-pipelines` selection.
3. Reuse the same `sync.py`, `notify.py`, and `config.json` as GitHub Actions for the same provider settings.
4. Keep the scripts and the configuration byte-identical to GitHub Actions.
5. Trigger the pipeline on a pull request merge and on a manual run.
6. Check out only the trusted merge commit, never content from an unmerged pull request.
7. Map each secret name one to one onto an Azure secret variable with the same name.
8. Keep the Telegram chat ID as a plain variable.
9. Send one plain-text summary to each selected Google Chat, Slack, and Telegram provider for a merged pull request only.

## Check

- Run `nix eval` with `ciProvider azure-pipelines`, enabled project issues, and each project provider.
- Show that the Azure pipeline file exists and the GitHub workflow file does not exist.
- Show that `sync.py`, `notify.py`, and `config.json` are byte-identical to the GitHub Actions selection.
- Show that Trello settings, type labels, board routing, and notification uses stay unchanged.
- Show that GitHub Actions files keep their bytes for the same settings.
