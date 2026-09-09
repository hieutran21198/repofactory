# Implementation plan: Documentation site deployment notifications

**Change:** [Send documentation site deployment notifications](../README.md)

## Order

1. [Add deployment notification delivery](task-add-deployment-notification.md).
2. [Document and check deployment notifications](task-check-deployment-notification.md).

## Completion

- The documentation site options select no provider, Google Chat, or Slack.
- A successful push or manual deployment sends one message when notification is enabled.
- A failed build or deployment sends no message.
- Unit tests cover messages, both providers, retries, and failures.
- Nix evaluation and repository checks pass.
