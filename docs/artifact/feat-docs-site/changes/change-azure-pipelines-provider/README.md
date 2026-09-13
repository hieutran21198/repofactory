# Change: Add Azure Pipelines provider

**Feature:** [Documentation site](../../README.md)
**From:** 4.0.3
**To:** 5.0.0
**Type:** Requirements

## Reason

Repository teams that use Azure Pipelines need the same documentation-site behavior that GitHub Actions provides today. The CI value `azure-pipelines` already exists in the factory. This change is additive. It adds an Azure Pipelines pipeline that builds Docusaurus and publishes to GitHub Pages on each push to the default branch. The GitHub Actions behavior does not change. The out-of-scope rule for other ci-cd providers stays, except for `azure-pipelines`.

## Artifacts

- [Requirements](requirements/README.md)
