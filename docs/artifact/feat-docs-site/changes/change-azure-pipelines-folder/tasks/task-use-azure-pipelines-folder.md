# task-use-azure-pipelines-folder: Use the selected Azure Pipelines folder

**Plan:** [Implementation plan](README.md)
**Covers:** req-docs-site-azure-pipelines-folder, spec-docs-site-files, spec-docs-site-azure-pipeline, spec-azure-static-web-app
**Context:** context-factory
**Component:** services/factory
**Aggregate:** agg-repository-blueprint
**Depends on:** none
**can-parallel:** no
**Parallel reason:** The next task checks this task in the same context and aggregate.

## Goal

Emit the docs-site Azure pipeline in the selected folder without a change to
the GitHub Actions bytes.

## Files

- `services/factory/composition/artifact-driven/docs-site/default.nix`

## Steps

1. Read `factory.domain.ci-cd.provider.azure-pipelines.folder` from the existing domain configuration.
2. Add the selected folder as the first input of the local Azure pipeline renderer.
3. Use the selected folder in the Azure trigger self-path.
4. Use the selected folder in the Azure pipeline file key.
5. Pass the same folder value to the renderer and the file key.
6. Keep `docs-site.yml` as the pipeline filename.
7. Add no docs-site option or folder assertion.
8. Keep all other Azure pipeline bytes unchanged for the same docs-site settings.
9. Keep the GitHub Actions renderer, path, and bytes unchanged.
10. Keep the generated user guide unchanged.

## Check

After the second task supplies the folder fixture, run these commands:

1. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
2. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`

Each command must exit with status zero. The checks must show these results:

- The default file and trigger path are `azure-pipelines/docs-site.yml`.
- A custom folder changes only the file path and the trigger self-path.
- The renderer and the file key use one folder value.
- The GitHub Actions workflow stays byte-identical.

## Errors

The Azure Pipelines provider domain must stop evaluation for an empty or
invalid folder. The docs-site composition must emit no pipeline file after
this error.
