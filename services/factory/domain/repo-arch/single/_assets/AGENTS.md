# Agent Guidance

Before you start work, read [Single Repository Architecture](docs/wiki/repo-arch/single-repository.md).

Keep the code in `src/`, the tests that start the complete component in `tests/`, and the
deployment configuration in `deployment/`. Keep the project knowledge in `docs/`.

Never change or commit directly to `main`. Before you make any change, create and check out a new
branch (for example `change-<name>`). Do all edits and commits on that branch. Merge to `main`
only after review.
