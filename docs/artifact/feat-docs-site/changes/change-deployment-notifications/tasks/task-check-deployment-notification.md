# task-check-deployment-notification: Document and check deployment notifications

**Plan:** [Implementation plan](README.md)
**Covers:** req-deployment-notification, spec-deployment-notification
**Context:** context-factory

## Work

1. Add the notification setup to the generated documentation site guide.
2. Add Nix checks for defaults, validation, generated files, and workflow text.
3. Update the documentation site master artifacts with the notification behavior.
4. Check the disabled, Google Chat, and Slack configurations.
5. Run all repository checks.

## Verification

Run the Python tests, the Nix evaluation, `git diff --check`, and `prek run --all-files`.
