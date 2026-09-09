# Specifications: Documentation site deployment notifications

**Change:** [Send documentation site deployment notifications](../README.md)

## Solution

Add an optional notification policy to the documentation site composition. The generated workflow
runs a dedicated notifier after GitHub Pages deploys the site. The notifier sends one message to
Google Chat or Slack.

## Specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-deployment-notification](spec-deployment-notification.md) | Configure and send a documentation site deployment message. | req-deployment-notification |

## Decisions

- [Use a dedicated incoming webhook notifier](../decisions/adr-incoming-webhook-delivery.md)
