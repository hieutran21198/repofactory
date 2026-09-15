# adr-incoming-webhook-delivery: Use repository-owned incoming webhook delivery

**Relates to:** spec-accepted-artifact-notification
**Context:** context-factory

## Context

Google Chat and Slack accept incoming webhook messages. The generated workflow needs a small and
portable notification mechanism.

## Options

1. Use provider actions from GitHub Marketplace. Pro: The workflow has little code. Con: Each
   provider adds a third-party workflow dependency.
2. Send incoming webhooks from a generated script. Pro: One repository-owned script supports both
   providers. Con: The factory owns HTTP retry behavior.
3. Use a bot application and OAuth. Pro: A bot can manage messages. Con: Setup and permissions are
   too complex for one acceptance summary.

## Decision

Use a generated Python script to send an incoming webhook. Use only the Python standard library.

## Consequences

The repository stores only the webhook secret name. GitHub Actions supplies the secret value. A
workflow rerun can send a duplicate message because incoming webhooks give at-least-once delivery.
