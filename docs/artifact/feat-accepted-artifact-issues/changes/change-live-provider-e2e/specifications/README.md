# Specifications: Live provider end-to-end checks

**Change:** [Add live provider end-to-end checks](../README.md)

## Solution

Add one local command-line check for GitHub Projects and Trello. The check deploys the generated
integration to two test repositories. It uses pull requests and GitHub Actions for each check.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-live-provider-e2e](spec-live-provider-e2e.md) | Check the artifact life cycle with both live providers. | req-accepted-only, req-artifact-hierarchy, req-portable-links, req-configurable-status |

## Decisions

- [Keep persistent provider sandboxes](../decisions/adr-persistent-sandboxes.md)

