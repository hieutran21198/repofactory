# Agent Guidance

Before you start work, read these pages:

- [Single Repository Architecture](docs/wiki/repo-arch/single-repository.md).
- [Artifact-Driven Documentation](docs/wiki/documentation/artifact-driven/README.md).
- [Domain-Driven Design](docs/wiki/design/ddd/README.md).
- [DDD in the Artifact-Driven Phases](docs/wiki/design/ddd/artifact-driven.md).

Keep the code in `src/`, the tests that start the complete component in `tests/`, and the
deployment configuration in `deployment/`.

Keep the requirements, the specifications, the decisions, and the tasks of each feature in
`docs/artifact/`. Do the five phases in order. Commit at the end of each phase.

Keep the domain model in `docs/domain/`. One bounded context is one directory in `src/`.
Update the domain artifacts in the phase that owns them: the strategic design in phase 1, the
tactical design in phase 2.
