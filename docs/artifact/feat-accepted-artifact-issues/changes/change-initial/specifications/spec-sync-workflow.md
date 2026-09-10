# spec-sync-workflow: Accepted artifact synchronization

**Master:** [Specifications](README.md)
**Covers:** req-accepted-only, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

GitHub Actions runs the synchronizer after an artifact pull request merges. A manual action scans
the complete artifact tree for setup and recovery.

## Contract

The workflow uses `pull_request_target` with activity `closed`. It continues only when the pull
request merged. It checks out the trusted merge commit and never runs content from an unmerged
pull request.

The workflow gives its automatic `GITHUB_TOKEN` write access to issues and pull requests. It uses
the pull request access only for the managed comment.

For each changed artifact:

1. Make each missing parent issue from the accepted tree.
2. Create or update the artifact issue.
3. Set the configured status for a new issue.
4. Keep the current status for an existing issue.
5. Change the issue identity when Git reports a rename.
6. Withdraw the issue when Git reports a deletion.
7. Add the issue URL to one managed pull request comment.

The manual action creates or updates every current artifact. It does not withdraw an issue because
the scan has no accepted deletion event.

When acceptance notification is enabled, the synchronizer writes a result for the changed artifact
files. A following step sends one summary for an automatic merged pull request. It sends no summary
for a manual scan or an empty result.

## Errors

- Stop before a write if the provider schema or credentials are not correct.
- Return success without writes when a merged pull request has no feature artifacts.
- Keep a partial-write report in the workflow log if an external API fails.
