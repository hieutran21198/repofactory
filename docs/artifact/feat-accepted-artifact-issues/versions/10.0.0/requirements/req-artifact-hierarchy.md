# req-artifact-hierarchy: Reproduce the artifact hierarchy

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must make one project issue for each feature artifact file. It must connect each
child issue to the issue of its parent artifact.

## Acceptance criteria

- Given a new feature tree, when its pull request merges, then CI makes the complete issue tree.
- Given a child without an issue for its parent, when CI synchronizes it, then CI makes the parent first.
- Given a changed artifact, when its pull request merges, then CI updates the existing issue.
- Given a renamed artifact, when its pull request merges, then CI keeps the issue and changes its identity.
- Given a deleted artifact, when its pull request merges, then CI withdraws the existing issue.

## Notes

The global `docs/artifact/README.md` file is an index. It does not make an issue.
