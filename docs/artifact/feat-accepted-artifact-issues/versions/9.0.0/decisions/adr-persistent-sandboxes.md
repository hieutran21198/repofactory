# adr-persistent-sandboxes: Keep persistent provider sandboxes

**Relates to:** spec-live-provider-e2e
**Context:** context-factory

## Decision

Keep one test repository for each provider. Keep one GitHub Project and one Trello board for all
checks.

## Options

1. Keep the resources. This option lets a maintainer examine a failed check and use the resources
   again.
2. Delete the resources after each check. This option keeps no provider data, but setup takes more
   time.
3. Use production resources. This option needs less setup, but test data can change production
   data.

## Consequences

The cleanup command closes or archives test items. It removes temporary branches. The provider
resources stay available for the next check.
