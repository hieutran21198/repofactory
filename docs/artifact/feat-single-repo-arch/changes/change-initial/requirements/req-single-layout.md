# req-single-layout: Seed the single repository layout

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

When `repo-arch.use` is `single`, the generator must seed a root layout with one directory for
the code, one for the tests of the complete component, one for the deployment configuration, and
one for the project knowledge. Each seeded directory must have a `README.md` that gives its
purpose.

## Acceptance criteria

- Given `repo-arch.use = "single"`, when the generator configures its files, then it includes
  `README.md`, `AGENTS.md`, `docs/README.md`, `docs/wiki/README.md`,
  `docs/wiki/repo-arch/single-repository.md`, `src/README.md`, `tests/README.md`, and
  `deployment/README.md`.
- Given `repo-arch.use = "single"`, when the generator configures its files, then each file of
  the single repository architecture uses the `seed` copy mode.
- Given `repo-arch.use = "multiple"`, when the generator configures its files, then it includes
  no `src/README.md` and no `tests/README.md`.
- Given `repo-arch.use = "single"`, when the generator configures its files, then it includes no
  `e2e/README.md`.
- Given the architecture page, when a user reads it, then it gives the purpose of each directory,
  the rules of the layout, and the step to take when the project needs a second component.

## Notes

The seeds are `README.md` files only. The layout is the same for every language.
