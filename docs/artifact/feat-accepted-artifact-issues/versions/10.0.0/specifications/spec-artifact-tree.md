# spec-artifact-tree: Artifact issue tree

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

Each Markdown file in one `docs/artifact/feat-*` tree has one artifact identity. The repository
and the repository-relative path form this identity. The global artifact index is not an artifact
issue. A feature holds its work in `changes/change-*/` and its state in `versions/<version>/`. A
file under `versions/` is a copy of accepted artifacts and gets no issue, no comment line, and no
notification. The root-level folders `feat-*/requirements/`, `specifications/`, `decisions/`, and
`tasks/` are not a supported form.

## Contract

| Path | Type | Parent |
| --- | --- | --- |
| `feat-*/README.md` | `feature-summary` | None |
| `feat-*/changes/change-*/README.md` | `change-summary` | Feature summary |
| `feat-*/changes/change-*/requirements/README.md` | `master-requirement` | Change summary |
| `feat-*/changes/change-*/requirements/req-*.md` | `requirement` | Master requirement in the same change |
| `feat-*/changes/change-*/specifications/README.md` | `master-specification` | Change summary |
| `feat-*/changes/change-*/specifications/spec-*.md` | `specification` | Master specification in the same change |
| `feat-*/changes/change-*/decisions/adr-*.md` | `decision` | The specification in `Relates to`, in the same change |
| `feat-*/changes/change-*/tasks/README.md` | `implementation-plan` | Change summary |
| `feat-*/changes/change-*/tasks/task-*.md` | `task` | Implementation plan in the same change |
| `feat-*/versions/**` | Ignored | None. No issue, no comment line, no notification. |
| Any other `feat-*/**/*.md` | Unsupported | None. The run stops. |

Use the first Markdown heading as the issue title. Use a hidden marker with the repository and
artifact path as the lookup key. A rename keeps the identity of the issue when the previous path
was an artifact or an unsupported path.

## Errors

- Stop if an added, modified, or renamed-to Markdown path under `feat-*` is unsupported. Name
  each path. A removed path and a renamed-from path are not checked.
- Stop if a decision does not name one related specification.
- Stop if a required parent artifact does not exist on the default branch.
- Do not stop on a path under `feat-*/versions/`. Make no project change for it.
