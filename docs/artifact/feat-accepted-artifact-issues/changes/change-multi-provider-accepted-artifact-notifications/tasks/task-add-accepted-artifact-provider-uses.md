# task-add-accepted-artifact-provider-uses: Add accepted-artifact provider uses

**Plan:** [Implementation plan](README.md)
**Covers:** req-multiple-accepted-artifact-providers, spec-multiple-accepted-artifact-providers
**Context:** context-factory

## Goal

The accepted-artifact notifier sends each summary to all selected providers.

## Steps

1. Replace the single provider option with `notification.uses` and provider settings.
2. Render the selected credentials and provider list in one workflow step.
3. Add Telegram delivery and independent provider failure handling.

## Check

Run the project issues evaluation and notifier tests.
