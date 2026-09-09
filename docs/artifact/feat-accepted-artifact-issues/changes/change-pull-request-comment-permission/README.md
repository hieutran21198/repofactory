# Change: Permit pull request comments

**Feature:** [Accepted artifact issues](../../README.md)

## Reason

The generated workflow gives read access to pull requests. GitHub rejects the managed pull request
comment with HTTP 403.

## Effect

This change gives the automatic GitHub Actions token write access to pull requests. It does not
change the access of the configured provider token.

## Artifacts

- [Specifications](specifications/README.md)
- [Implementation plan](tasks/README.md)
