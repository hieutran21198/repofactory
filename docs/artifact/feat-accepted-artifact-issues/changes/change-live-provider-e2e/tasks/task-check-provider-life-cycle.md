# task-check-provider-life-cycle: Check the provider life cycle

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status, spec-live-provider-e2e
**Context:** context-factory

## Goal

Run the full artifact life cycle with GitHub Projects and Trello.

## Steps

1. Check the credentials.
2. Run the local Nix and Python checks.
3. Run `setup` for the two providers.
4. Run the GitHub Projects check.
5. Run the Trello check.
6. Check the result report.
7. Check the closed GitHub issues and the archived Trello cards.

## Check

Each scenario passes. The provider resources stay available for inspection.
