# spec-comment-permission: Give access to write the managed comment

**Master:** [Specifications](README.md)
**Covers:** req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Workflow contract

The generated workflow sets `pull-requests: write` in its `permissions` map. It keeps
`issues: write` for repository issues and `contents: read` for the accepted artifact tree.

The automatic `GITHUB_TOKEN` writes the managed pull request comment. The configured provider
token continues to make GitHub Project API requests only.

## Check contract

A module evaluation check must find `pull-requests: write` in each generated provider workflow.
