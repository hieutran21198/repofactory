# task-github-projects: Add the GitHub Projects adapter

**Plan:** [Implementation plan](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, req-portable-links, spec-github-projects
**Context:** context-factory

## Goal

Synchronize artifact issues, sub-issues, and project statuses through GitHub APIs.

## Steps

1. Check the configured project and status options.
2. Create or update repository issues by artifact identity.
3. Add each issue to the selected project.
4. Connect each child to its native parent issue.
5. Close withdrawn artifact issues.

## Check

Run adapter checks with recorded GitHub API responses and requests.
