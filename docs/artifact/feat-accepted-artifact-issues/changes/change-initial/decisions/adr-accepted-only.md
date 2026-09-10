# adr-accepted-only: Create issues after acceptance

**Relates to:** spec-sync-workflow
**Context:** context-factory

## Context

Artifact proposals need review, but rejected proposals must not add project data. Git must stay the
acceptance record.

## Options

1. Create issues when a pull request opens. Pro: The board shows review work. Con: Rejected work adds board data.
2. Create issues when a pull request merges. Pro: The board contains accepted artifacts. Con: The board does not show review work.

## Decision

Create or update issues only after merge. Keep proposal review in the pull request.

## Consequences

The board contains no rejected proposal. The pull request keeps the complete review history.
