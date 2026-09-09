# task-check-accepted-artifact-notifications: Document and check notifications

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-artifact-notification, spec-accepted-artifact-notification
**Context:** context-factory

## Work

1. Add Google Chat and Slack examples to the generated project issues guide.
2. Add webhook and GitHub secret procedures to the generated credential guide.
3. Update the feature master artifacts with the current notification behavior.
4. Check generated workflows for GitHub Projects and Trello.
5. Run all repository checks.

## Verification

Run the Python tests, the Nix evaluation, `git diff --check`, and `prek run --all-files`.
