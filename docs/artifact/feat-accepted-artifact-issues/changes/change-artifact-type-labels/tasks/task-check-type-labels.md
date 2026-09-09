# task-check-type-labels: Check provider type labels

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-type-labels, spec-artifact-type-labels
**Context:** context-factory

## Goal

Verify artifact type labels through the complete provider lifecycle.

## Steps

1. Update each provider inspector to read managed labels.
2. Verify one correct managed label on each provider item.
3. Add a user label to one item.
4. Update the artifact and verify that the user label stays.
5. Verify type labels after rename, withdraw, and cleanup.
6. Update the generated setup documentation and master specifications.
7. Run the local Python and Nix checks.
8. Run the live lifecycle for both providers.

## Check

Run `python3 accepted-artifact-issues/e2e.py test` from the `e2e` development environment.
