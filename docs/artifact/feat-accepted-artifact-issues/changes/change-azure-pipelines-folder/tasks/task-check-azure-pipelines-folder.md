# task-check-azure-pipelines-folder: Add evaluation checks for the folder contract

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-folder, spec-ci-cd-provider, spec-factory-options, spec-azure-pipelines-sync

## Goal

The evaluation suite checks the folder default, validation, pipeline emission, content, and CI isolation.

## Component files

- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Add a folder argument to the evaluation setup with the default `azure-pipelines`.
2. Add a case that emits `azure-pipelines/accepted-artifact-issues.yml` with the default folder.
3. Add a valid nested-folder case that emits `<folder>/accepted-artifact-issues.yml`.
4. Compare the default-folder and custom-folder pipeline content byte for byte.
5. Check that the custom case does not emit the default-path file.
6. Add invalid cases for an empty value, an absolute path, and an empty segment.
7. Add invalid cases for a `.` segment, a `..` segment, and a backslash.
8. Check the strict validation for `unset`, `github-actions`, and `azure-pipelines` selections.
9. Check that each error names the option and the failed validation rule.
10. Check that each invalid value stops evaluation before any pipeline file emission.
11. Check that a custom folder changes no GitHub Actions path or file.
12. Keep the existing Azure Pipelines and GitHub Actions checks unchanged.

## Check

- Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
- Confirm that all assertions return `true`.
- Confirm default and custom paths for `<folder>/accepted-artifact-issues.yml`.
- Confirm unchanged pipeline content for default and custom folders.
- Confirm rejection before emission for all six invalid folder classes.
- Confirm that a custom folder changes no GitHub Actions path or file.
