# task-add-deployment-notification: Add deployment notification delivery

**Plan:** [Implementation plan](README.md)
**Covers:** req-deployment-notification, spec-deployment-notification
**Context:** context-factory

## Work

1. Add the notification provider and webhook secret options.
2. Check the secret name when a provider is selected.
3. Generate the notifier only when a provider is selected.
4. Render the workflow with notification steps after the deployment step.
5. Build the deployment message from the GitHub Actions environment.
6. Send the provider webhook with the specified retries and safe errors.
7. Add unit tests for messages, payloads, retries, and failures.

## Verification

Run the notifier unit tests and parse the documentation site module.
