# spec-single-seed: Define the single repository seeds

**Master:** [Specifications](README.md)
**Covers:** req-single-layout

## Description

The module `services/factory/domain/repo-arch/single/default.nix` seeds the files of the single
repository architecture. The module has the same shape as the multiple repositories module. It
knows nothing about the documentation model or the design method.

## Contract

When `repo-arch.use` is `single`, the module adds these file declarations. The source of each
target is the file with the same path in `_assets/`.

| Target | Copy mode |
| --- | --- |
| `README.md` | `seed` |
| `AGENTS.md` | `seed` |
| `docs/README.md` | `seed` |
| `docs/wiki/README.md` | `seed` |
| `docs/wiki/repo-arch/single-repository.md` | `seed` |
| `src/README.md` | `seed` |
| `tests/README.md` | `seed` |
| `deployment/README.md` | `seed` |

The `seed` mode writes the target one time and keeps the edits of the user.

The module declares no other file. It does not seed `e2e/README.md`, `apps/`, `services/`, or
`libs/`.

## Errors

Nix evaluation fails if a source path does not exist.
The check fails if the module emits a file when `repo-arch.use` is not `single`.
The check fails if the multiple repositories module emits `src/README.md` or `tests/README.md`.
