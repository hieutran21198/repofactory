# spec-github-projects: GitHub Projects adapter

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The GitHub adapter creates repository issues, connects native sub-issues, and adds each issue to
one GitHub Project. The project `Status` field supplies the configured artifact status.

## Contract

- Use `GITHUB_TOKEN` with issue write access for repository issues.
- Give `GITHUB_TOKEN` pull request write access for the managed pull request comment.
- Use the configured PAT secret for GitHub Project GraphQL calls.
- Find the project by owner type, owner name, and project number.
- Require one single-select field named `Status`.
- Find managed issues by their hidden artifact marker.
- Add exactly one managed `artifact:<kind>` label and preserve other labels.
- Create parent issues before child issues.
- Add child issues through the GitHub sub-issues API.
- Close a withdrawn artifact issue after its project status changes.
- Create missing managed labels in the repository.

## Errors

- Stop if the project, `Status` field, or configured status option does not exist.
- Stop if two repository issues contain the same artifact marker.
- Stop if a parent issue cannot accept another sub-issue.
