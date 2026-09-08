# task-verify-generation: Verify the generated files

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-guidance, req-single-context-rule

## Goal

A generated project has the DDD files of its active architecture only.

## Steps

1. Copy the repository to a scratch directory without `.git`, `.devenv`, and the harness output.
2. Set `repo-arch.use = "single"` and enter the shell. Search `docs/wiki/design/ddd/` and the
   solution expert file of each harness for `services/`. Search them for `src/`.
3. Set `repo-arch.use = "multiple"` and enter the shell. Search the same files for `src/`.
4. Set `repo-arch.use = "unset"` and enter the shell. List `docs/domain/` and
   `docs/wiki/design/ddd/`.
5. In this repository, enter the shell. The tracked copies under `docs/wiki/design/ddd/` return
   to the wording of the multiple repositories architecture. Commit them with the change.
6. Update the master artifacts of the feature: `spec-single-context-home`,
   `spec-single-composition`, and the feature summary.
7. Run `git diff --check`.

## Check

Step 2 finds no `services/` and finds `src/`. Step 3 finds no `src/`. Step 4 shows the seeds in
`docs/domain/` and no `docs/wiki/design/ddd/` written by the shell. Step 7 reports no error.
