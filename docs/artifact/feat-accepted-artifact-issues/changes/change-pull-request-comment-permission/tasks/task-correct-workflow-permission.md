# task-correct-workflow-permission: Correct the workflow permission

**Master:** [Implementation plan](README.md)
**Covers:** req-portable-links, spec-comment-permission
**Context:** context-factory

## Work

1. Change the generated pull request permission to `write`.
2. Add a module evaluation check for the permission.
3. Update the master specifications.

## Done when

- Each provider workflow contains `pull-requests: write`.
- The module evaluation check passes.
