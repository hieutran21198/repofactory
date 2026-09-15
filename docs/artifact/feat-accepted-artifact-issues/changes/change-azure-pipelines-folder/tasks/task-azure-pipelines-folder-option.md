# task-azure-pipelines-folder-option: Add and validate the Azure Pipelines folder option

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-folder, spec-ci-cd-provider, spec-factory-options, adr-azure-pipelines-folder-option

## Goal

The Azure Pipelines provider owns a folder option with the required default and strict validation.

## Component files

- `services/factory/domain/ci-cd/provider/azure-pipelines/default.nix`

## Steps

1. Add the string option `factory.domain.ci-cd.provider.azure-pipelines.folder`.
2. Set its default value to `azure-pipelines`.
3. Validate the folder for all CI provider selections.
4. Accept only a non-empty relative POSIX repository path.
5. Reject a value that starts with `/` or contains a backslash.
6. Reject an empty segment, a `.` segment, or a `..` segment.
7. Name the option and the failed rule in each error.
8. Stop evaluation before the factory emits blueprint files after a folder error.
9. Keep the provider selection independent from the project-issues composition activation.
10. Expose the validated folder for `<folder>/accepted-artifact-issues.yml` emission with unchanged content.

## Check

- Evaluate the option with its default value and with a valid nested folder.
- Check each invalid class: empty, absolute, empty segment, `.`, `..`, and backslash.
- Check invalid values with `unset`, `github-actions`, and `azure-pipelines` selections.
- Check that each error names the option and its failed rule.
- Check that an option error stops evaluation before any pipeline file emission.
- After task 3, run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
