# spec-artifact-tree: Artifact issue tree

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

Each Markdown file in one `docs/artifact/feat-*` tree has one artifact identity. The repository
and repository-relative path form this identity. The global artifact index is not an artifact
issue.

## Contract

| Path | Type | Parent |
| --- | --- | --- |
| `feat-*/README.md` | `feature-summary` | None |
| `requirements/README.md` | `master-requirement` | Feature summary |
| `requirements/req-*.md` | `requirement` | Master requirement |
| `specifications/README.md` | `master-specification` | Feature summary |
| `specifications/spec-*.md` | `specification` | Master specification |
| `decisions/adr-*.md` | `decision` | The specification in `Relates to` |
| `tasks/README.md` | `implementation-plan` | Feature summary |
| `tasks/task-*.md` | `task` | Implementation plan |
| `changes/change-*/README.md` | `change-summary` | Feature summary |
| A master file in a change | The matching master type | Change summary |
| A leaf file in a change | The matching leaf type | Its master or related specification |

Use the first Markdown heading as the issue title. Use a hidden marker with the repository and
artifact path as the lookup key.

## Errors

- Stop if an accepted Markdown path does not match a supported artifact form.
- Stop if a decision does not name one related specification.
- Stop if a required parent artifact does not exist on the default branch.
