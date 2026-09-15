# task-azure-pipelines-folder-emission: Emit the pipeline in the selected folder

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-folder, spec-factory-options, spec-azure-pipelines-sync

## Goal

The project-issues composition emits the Azure pipeline in the selected folder without a content change.

## Component files

- `services/factory/composition/artifact-driven/default.nix`

## Steps

1. Read `factory.domain.ci-cd.provider.azure-pipelines.folder` from the CI provider domain.
2. Emit the Azure pipeline at `<folder>/accepted-artifact-issues.yml`.
3. Keep `azure-pipelines/accepted-artifact-issues.yml` as the path for the default folder.
4. Use the existing Azure pipeline text for default and custom folders.
5. Keep the emitted pipeline content unchanged when the folder changes.
6. Emit the pipeline only for an enabled project-issues composition with Azure Pipelines.
7. Rely on the domain validation before the composition emits files.
8. Do not emit a pipeline for an empty, absolute, segmented, or backslash folder error.
9. Keep `.github/workflows/accepted-artifact-issues.yml` and all GitHub Actions files unchanged.

The segmented folder errors include an empty segment, a `.` segment, and a `..` segment.
The domain validates the folder for every CI provider selection.

## Check

- Evaluate the composition with the default folder and confirm the default pipeline path.
- Evaluate it with `ci/azure` and confirm `ci/azure/accepted-artifact-issues.yml`.
- Confirm that the default-path file is absent for the custom-folder evaluation.
- Compare the default-folder and custom-folder pipeline text byte for byte.
- Check that each invalid folder stops evaluation and emits no pipeline file.
- Check that a custom folder changes no GitHub Actions path or file.
- After task 3, run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
