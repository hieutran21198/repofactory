# spec-multiple-deployment-providers: Deliver deployment messages to multiple providers

**Master:** [Specifications](README.md)
**Covers:** req-multiple-deployment-providers
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Configuration contract

`notification.uses` is an ordered list of `"google-chat"`, `"slack"`, and `"telegram"`. Its default is `[]`.
Each provider can occur once. Google Chat and Slack use `webhook-secret`. Telegram uses `token-secret` and `chat-id`.

## Delivery contract

The workflow runs one notifier after a successful deployment. The notifier sends the same plain-text message to every selected provider.
It sends `{"text": "..."}` to webhook providers. It sends `{"chat_id": "...", "text": "..."}` to Telegram Bot API `sendMessage`.

The notifier retries a network error, HTTP 429, and HTTP 5xx three times. It tries all selected providers and then fails when one or more providers fail.

## Errors

The factory rejects an unsupported or duplicate provider, an invalid selected-provider secret name, and a Telegram provider without a chat ID.
The notifier does not print a webhook URL or bot token.
