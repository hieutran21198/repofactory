# task-check-provider-credential-guide: Check conditional generation

**Plan:** [Implementation plan](README.md)
**Covers:** spec-provider-credential-guide
**Context:** context-factory

## Goal

Check that the composition emits the credential page only when project issues are enabled.

## Steps

1. Add the credential page to the expected project-issue files.
2. Check enabled GitHub Projects configuration.
3. Check enabled Trello configuration.
4. Check disabled project-issues configuration.
5. Run the composition evaluation checks.

## Check

Confirm that all project-issues evaluation assertions pass.
