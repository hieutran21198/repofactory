# req-multiple-deployment-providers: Send deployment messages to selected providers

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must let a repository maintainer select one or more notification providers for a deployment notification.

## Acceptance criteria

- Given Google Chat, Slack, and Telegram are selected, when a deployment succeeds, then each provider receives one deployment message.
- Given Telegram is selected, when the workflow sends a message, then Telegram receives the repository, site URL, source revision, and run URL.
- Given one provider delivery fails, when other providers are selected, then the workflow tries each other provider.
- Given no provider is selected, when the factory composes the repository, then it adds no deployment notifier.
- Given delivery retries end, when the workflow reports a failure, then it does not report a credential.

## Notes

`notification.provider` and `notification.webhook-secret` are replaced by `notification.uses` and provider settings.
