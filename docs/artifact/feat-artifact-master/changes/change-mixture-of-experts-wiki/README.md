# Change: Mixture of experts wiki

**Feature:** [Artifact master](../../README.md)
**From:** 1.0.0
**To:** 2.0.0
**Type:** Requirements

## Reason

The software team and the end-user maintainer need one wiki page that explains the
mixture-of-experts idea that artifact-driven uses: a coordinator role plus expert roles, and the
routing between them. Without this page, a new reader cannot see why the artifact master owns
coordination only, which expert owns the content of each phase, or how one canonical role reaches
each harness in use. The page must live in `docs/wiki/` and must reach a generated repository
through the Nix wiki assets copy, the same way the existing wiki docs do, so that the end-user
can copy a self-contained page. New wiki delivery capability is a new requirement, so the change
bumps the major version.

## Artifacts

- [Requirements](requirements/README.md)
