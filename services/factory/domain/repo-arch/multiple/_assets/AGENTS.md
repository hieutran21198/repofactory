# Agent Guidance

Before you start work, read [Multiple Repositories Architecture](docs/wiki/repo-arch/multiple-repositories.md).

Keep the implementation artifacts and the local rules of each component in its own directory.
The directory is in `apps/`, `services/`, `libs/`, `deployment/`, or `e2e/`.

Never change or commit directly to `main`. Before you make any change, create and check out a new
branch (for example `change-<name>`). Do all edits and commits on that branch. Merge to `main`
only after review.
