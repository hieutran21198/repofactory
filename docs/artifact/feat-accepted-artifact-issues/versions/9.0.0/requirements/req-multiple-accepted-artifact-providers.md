# req-multiple-accepted-artifact-providers: Send accepted-artifact messages to selected providers

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must let a repository maintainer select one or more notification providers for an accepted-artifact notification.

## Acceptance criteria

- Given Google Chat, Slack, and Telegram are selected, when synchronization succeeds with artifact changes, then each provider receives one summary.
- Given Telegram is selected, when the workflow sends a summary, then Telegram receives the pull request and artifact changes.
- Given one provider delivery fails, when other providers are selected, then the workflow tries each other provider.
- Given no provider is selected, when the factory composes the repository, then it adds no accepted-artifact notifier.
- Given synchronization has no artifact changes, when the workflow ends, then it sends no notification.
- Given delivery retries end, when the workflow reports a failure, then it does not report a credential.

## Notes

`notification.provider` and `notification.webhook-secret` are replaced by `notification.uses` and provider settings.
