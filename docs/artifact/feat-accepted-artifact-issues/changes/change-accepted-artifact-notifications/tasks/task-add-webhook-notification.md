# task-add-webhook-notification: Add webhook notification delivery

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-artifact-notification, spec-accepted-artifact-notification
**Context:** context-factory

## Work

1. Add the notification provider and webhook secret options.
2. Validate enabled notification configuration.
3. Generate the notifier and its workflow step only when a provider is selected.
4. Build one bounded plain-text message from the synchronization result.
5. Send the provider webhook with the specified retries and safe errors.
6. Add unit tests for payloads, suppression, retries, and failures.

## Verification

Run the notifier unit tests and the artifact-driven composition evaluation.
