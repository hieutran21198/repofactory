# task-add-github-labels: Add GitHub type labels

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-type-labels, spec-artifact-type-labels
**Context:** context-factory

## Goal

Show the artifact type on each GitHub issue and its GitHub Project item.

## Steps

1. Read repository labels during preflight.
2. Create missing managed labels with their configured colors.
3. Include labels when the adapter reads managed issues.
4. Apply the current type label during each upsert.
5. Remove obsolete managed labels and preserve user labels.
6. Add tests for create, update, rename, and withdraw operations.

## Check

Use recorded GitHub API requests to verify label creation and issue updates.
