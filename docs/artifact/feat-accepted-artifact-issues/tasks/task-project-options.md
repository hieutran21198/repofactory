# task-project-options: Define project-management options

**Plan:** [Implementation plan](README.md)
**Covers:** req-configurable-status, spec-factory-options
**Context:** context-factory

## Goal

Add typed Nix options for artifact statuses, GitHub Projects, and Trello.

## Steps

1. Add the shared artifact status options.
2. Add the GitHub Project location and token-secret options.
3. Add the Trello board and token-secret options.
4. Add selected-provider assertions.

## Check

Evaluate valid and invalid provider configurations with Nix module checks.
