# req-azure-pipelines-folder: Select the Azure Pipelines folder

**Master:** [Requirements](README.md)
**Covers:** none (new requirement)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must offer a domain option that selects the Azure Pipelines
folder. The factory must emit the project-issues pipeline file
`accepted-artifact-issues.yml` in the selected folder.

## Acceptance criteria

- Given a repository that uses Azure Pipelines and leaves the folder option unset, when the factory emits the blueprint, then the project-issues pipeline path is `azure-pipelines/accepted-artifact-issues.yml`.
- Given a repository that uses Azure Pipelines and sets a custom folder, when the factory emits the blueprint, then the project-issues pipeline path is `<folder>/accepted-artifact-issues.yml` with unchanged content.
- Given a repository that sets an empty folder value, when the factory evaluates the blueprint, then it rejects the value with a clear error and emits no pipeline file.
- Given a repository that sets a folder value with an invalid path, when the factory evaluates the blueprint, then it rejects the value with a clear error and emits no pipeline file.
- Given a repository that uses GitHub Actions, when the factory emits the blueprint, then the folder option changes no GitHub Actions path.

## Notes

The default preserves the current behavior. The docs-site pipeline path is out
of scope for this change. A follow-up change defines it.
