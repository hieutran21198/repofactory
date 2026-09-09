# task-add-provider-test-component: Add the provider test component

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status, spec-live-provider-e2e
**Context:** context-factory

## Goal

Add a reusable component that deploys and checks the generated provider integration.

## Steps

1. Add the separate development environment in `e2e/`.
2. Add the Nix expression that renders the generated integration files.
3. Add the provider setup commands.
4. Add the pull request and workflow commands.
5. Add the GitHub Projects assertions.
6. Add the Trello assertions.
7. Add the cleanup command.
8. Add the operating instructions.

## Check

Run the command-line help and the local checks. Make sure that no command writes a credential to
a file or to the output.

