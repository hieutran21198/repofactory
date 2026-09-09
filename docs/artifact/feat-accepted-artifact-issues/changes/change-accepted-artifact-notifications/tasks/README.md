# Implementation plan: Accepted artifact notifications

**Change:** [Send accepted artifact notifications](../README.md)

## Order

1. [Write the synchronization result](task-write-synchronization-result.md).
2. [Add webhook notification delivery](task-add-webhook-notification.md).
3. [Document and check notifications](task-check-accepted-artifact-notifications.md).

## Completion

- The Factory options select no provider, Google Chat, or Slack.
- A successful merged artifact pull request sends one summary when notification is enabled.
- Unit tests cover result generation, message generation, suppression, retries, and failures.
- Nix evaluation and repository checks pass.
