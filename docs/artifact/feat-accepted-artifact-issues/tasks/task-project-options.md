# task-project-options: Define provider and composition options

**Plan:** [Implementation plan](README.md)
**Covers:** req-configurable-status, spec-factory-options
**Context:** context-factory

## Goal

Add typed Nix options for composition activation, artifact statuses, GitHub Projects, and Trello.

## Steps

1. Add the composition enable and artifact status options.
2. Add the GitHub Project location and token-secret provider options.
3. Add the Trello board and token-secret provider options.
4. Add enabled-composition assertions for its domain dependencies and selected adapter.

## Check

Evaluate enabled, disabled, valid, and invalid compositions with Nix module checks.
