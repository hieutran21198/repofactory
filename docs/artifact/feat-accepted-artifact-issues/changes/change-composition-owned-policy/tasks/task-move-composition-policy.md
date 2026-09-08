# task-move-composition-policy: Move the composition policy

**Plan:** [Implementation plan](README.md)
**Covers:** req-configurable-status, req-accepted-only, spec-composition-options
**Context:** context-factory

## Goal

Put integration activation and artifact statuses in the artifact-driven project-issues
composition. Keep adapter targets and credential names in project-management providers.

## Steps

1. Remove the domain-level artifact status option and its assertions.
2. Add the disabled-by-default project-issues composition options.
3. Generate integration files only when the composition is enabled.
4. Validate compatible domains, statuses, and the selected adapter only when enabled.
5. Build generated configuration from composition policy and provider adapter settings.
6. Update the setup guide and master artifacts to show the corrected interface.

## Check

Evaluate enabled and disabled GitHub Projects and Trello configurations.
