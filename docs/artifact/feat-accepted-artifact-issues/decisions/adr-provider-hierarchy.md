# adr-provider-hierarchy: Use provider-native issue forms

**Relates to:** spec-github-projects, spec-trello
**Context:** context-factory

## Context

GitHub Project draft items do not supply the required repository issue hierarchy. Trello does not
supply native sub-issues.

## Options

1. Use one flat draft item form for both providers. Pro: The adapters are similar. Con: The hierarchy is not visible.
2. Use repository issues and Trello linked cards. Pro: Each provider shows the hierarchy. Con: The adapters use different mechanisms.

## Decision

Use native GitHub repository issues and sub-issues. Use Trello cards, parent fields, and child
checklists.

## Consequences

GitHub shows native sub-issue progress. Trello shows a logical hierarchy through card links.
