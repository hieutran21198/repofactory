# task-check-integration: Check the integration

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status
**Context:** context-factory

## Goal

Check the full generated integration and its failure responses.

## Steps

1. Run the Nix evaluation checks.
2. Run the synchronizer unit checks.
3. Check the generated workflow syntax.
4. Check shell and Python syntax.
5. Run the repository checks.

## Check

All repository checks pass, and Git reports no whitespace errors.
