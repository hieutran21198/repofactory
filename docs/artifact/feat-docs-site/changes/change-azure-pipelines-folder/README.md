# Change: Azure Pipelines folder for the docs-site pipeline

**Feature:** [Documentation site](../../README.md)
**From:** 7.0.0
**To:** 8.0.0
**Type:** Requirements

## Reason

The factory emits the docs-site pipeline at a fixed path.
`services/factory/composition/artifact-driven/docs-site/default.nix` names
`azure-pipelines/docs-site.yml` at line 281 (the trigger self-path) and at
line 571 (the emission path). A maintainer who selects a custom Azure
Pipelines folder still gets the docs-site pipeline in `azure-pipelines/`.
The project-issues pipeline already follows the folder option. The change
[change-azure-pipelines-folder](../../../feat-accepted-artifact-issues/changes/change-azure-pipelines-folder/README.md)
of `feat-accepted-artifact-issues` names this docs-site work as the follow-up
step. This change defines the docs-site pipeline path in the selected folder.
The default folder stays `azure-pipelines`, so existing repositories do not
change unless the maintainer sets the option.

## Artifacts

- [Requirements](requirements/README.md)
