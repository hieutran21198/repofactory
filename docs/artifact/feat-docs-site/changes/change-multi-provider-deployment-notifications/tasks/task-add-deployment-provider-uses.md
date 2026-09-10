# task-add-deployment-provider-uses: Add deployment provider uses

**Plan:** [Implementation plan](README.md)
**Covers:** req-multiple-deployment-providers, spec-multiple-deployment-providers
**Context:** context-factory

## Goal

The documentation site notifier sends each deployment message to all selected providers.

## Steps

1. Replace the single provider option with `notification.uses` and provider settings.
2. Render the selected credentials and provider list in one workflow step.
3. Add Telegram delivery and independent provider failure handling.

## Check

Run the documentation site evaluation and notifier tests.
