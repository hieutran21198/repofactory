# Implementation plan: Documentation site generated assets

**Change:** [Add generated asset extension points](../../../changes/change-generated-asset-extension-points/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Add typed extension options](task-add-typed-extension-options.md) | - |
| 2 | [Connect static directories and document the workflow](task-connect-static-directories.md) | 1 |
| 3 | [Check generated asset extensions](task-check-generated-asset-extensions.md) | 1, 2 |

## Definition of done

- The docs-site module exposes each typed extension option with an empty-list default.
- The Docusaurus config and workflow consume the extension values at the specified points.
- The documentation contains a complete LaTeX-to-PDF example.
- All evaluation and regression checks pass.
- A configuration without extension values keeps the version 3.0.0 behavior.
