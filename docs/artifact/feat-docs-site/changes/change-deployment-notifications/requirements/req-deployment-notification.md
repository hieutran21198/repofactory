# req-deployment-notification: Notify a team after a site deployment

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must optionally notify one team destination after the documentation site deploys.

## Acceptance criteria

- Given no notification provider, the factory generates no notifier or notification workflow step.
- Given Google Chat or Slack, a successful deployment sends one message.
- Given a push or a manual workflow run, a successful deployment sends one message.
- Given a deployment message, it identifies the repository, site, source revision, and workflow run.
- Given a failed build or deployment, the workflow sends no deployment notification.
- Given a notification delivery failure, the workflow retries delivery and reports the last failure.
- Given a configured webhook, the workflow does not write its URL to a log or generated file.
