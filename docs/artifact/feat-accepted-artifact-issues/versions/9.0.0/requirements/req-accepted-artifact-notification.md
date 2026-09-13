# req-accepted-artifact-notification: Notify a team about accepted artifacts

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

Superseded by [req-multiple-accepted-artifact-providers](req-multiple-accepted-artifact-providers.md) for the number of destinations: a notification goes to all selected providers, not to one team destination. The content of the notification still applies.

## Statement

The factory must optionally notify one team destination after accepted artifact synchronization.

## Acceptance criteria

- Given no notification provider, when the factory composes a repository, then notification stays
  disabled.
- Given Google Chat or Slack, when artifact synchronization succeeds, then the workflow sends one
  pull request summary.
- Given an artifact summary, then it identifies added, updated, renamed, and withdrawn artifacts.
- Given a rejected pull request, a manual scan, or no artifact change, then the workflow sends no
  notification.
- Given synchronization failure, then the workflow sends no acceptance notification.
- Given notification delivery failure, then the workflow retries delivery and reports a failure.
- Given a configured webhook, then the workflow does not write its URL to a log or generated file.
