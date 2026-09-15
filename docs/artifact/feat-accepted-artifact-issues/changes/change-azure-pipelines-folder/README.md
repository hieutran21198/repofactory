# Change: Azure Pipelines folder

**Feature:** [Accepted artifact issues](../../README.md)
**From:** 9.0.0
**To:** 10.0.0
**Type:** Requirements

## Reason

Maintainers use Azure DevOps setups that require a different pipeline folder.
Today the factory emits the project-issues pipeline at a fixed path under
`azure-pipelines`. These maintainers cannot relocate that pipeline. The factory
must offer a domain option that changes the Azure Pipelines folder. The default
must stay `azure-pipelines` so existing repositories do not change. This change
defines the folder option and the project-issues pipeline path. A follow-up
change defines the docs-site pipeline path.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
