# Agent Guidance

Before you start work, read these pages:

- [Single Repository Architecture](docs/wiki/repo-arch/single-repository.md).
- [Artifact-Driven Documentation](docs/wiki/documentation/artifact-driven/README.md).

Keep the code in `src/`, the tests that start the complete component in `tests/`, and the
deployment configuration in `deployment/`.

Keep the artifacts of each feature in `docs/artifact/feat-<name>/`. Each unit of work is a change
in `changes/change-<name>/`. Each version in `versions/<version>/` holds the full state of the
feature. Read the current version for the state of a feature. Do the five phases in order. Commit
at the end of each phase.

Coordinate each change with the `artifact-master` role (opencode) or skill (claude, codex).
Do one phase at a time with Plan-Pn then Build-Pn. Do not plan all five phases in one pass.

Never change or commit directly to `main`. Before you make any change, create and check out a new
branch (for example `change-<name>`). Do all edits and commits on that branch. Merge to `main`
only after review.
