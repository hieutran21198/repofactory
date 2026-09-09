# adr-incoming-webhook-delivery: Use a dedicated incoming webhook notifier

**Relates to:** spec-deployment-notification
**Context:** context-factory

## Context

Google Chat and Slack accept incoming webhook messages. The documentation site can work without
the accepted artifact composition. Its notification delivery must not depend on that composition.

## Options

1. Use provider actions from GitHub Marketplace. The workflow has little code. Each provider adds
   a third-party workflow dependency.
2. Reuse the accepted artifact notifier. This removes duplicate transport code. It couples the
   documentation site to an artifact-specific interface and path.
3. Generate a dedicated Python script. This keeps the two compositions independent. The factory
   owns two small webhook implementations.

## Decision

Generate a dedicated Python script. Use only the Python standard library. Use the same payload,
retry, and safe-error rules as the accepted artifact notifier.

## Consequences

The documentation site works when the accepted artifact composition is disabled. The repository
stores only the secret name. GitHub Actions supplies the secret value. A workflow rerun can send a
duplicate message.
