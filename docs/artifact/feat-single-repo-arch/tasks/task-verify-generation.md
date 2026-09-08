# task-verify-generation: Verify the generated files

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-layout, req-single-guidance

## Goal

The generated repository has the single repository files when the option is set, and has none
of them when the option is `multiple`.

## Steps

1. Set `repo-arch.use = "single"` in `devenv.local.nix` and enter the shell.
2. List `src/`, `tests/`, and `docs/wiki/repo-arch/`. Read the sources of `AGENTS.md` and
   `docs/wiki/README.md` in `.devenv/state/files.json`. The seed mode does not overwrite the
   files that exist in this repository.
3. Restore `repo-arch.use = "multiple"` and enter the shell.
4. Delete the files that step 1 seeded. They belong to a single repository project, not to
   this repository.
5. Run `git diff --check`.

## Check

Step 2 shows `src/README.md`, `tests/README.md`, and `single-repository.md`, and the sources
in `_assets/single/`. Step 3 restores the sources in `_assets/` of the multiple repositories
architecture. Step 5 reports no error.
