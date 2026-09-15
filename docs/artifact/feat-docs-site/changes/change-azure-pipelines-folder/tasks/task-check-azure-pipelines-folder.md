# task-check-azure-pipelines-folder: Check the selected Azure Pipelines folder

**Plan:** [Implementation plan](README.md)
**Covers:** req-docs-site-azure-pipelines-folder, spec-docs-site-files, spec-docs-site-azure-pipeline, spec-azure-static-web-app, spec-eval-checks
**Context:** context-factory
**Component:** services/factory
**Aggregate:** agg-repository-blueprint
**Depends on:** task-use-azure-pipelines-folder
**can-parallel:** no
**Parallel reason:** This task checks the first task and touches the same context and aggregate.

## Goal

Check the default folder, a custom folder, central validation, and unchanged
GitHub Actions output.

## Files

- `services/factory/composition/artifact-driven/docs-site/tests/eval.nix`

## Steps

1. Add a `folder` input to the `moduleFor` test fixture.
2. Set the fixture default to `azure-pipelines`.
3. Supply the folder under `factory.domain.ci-cd.provider.azure-pipelines.folder`.
4. Keep the existing default Azure configuration.
5. Add an Azure configuration with folder `ci/azure`.
6. Add a GitHub Actions configuration with folder `ci/azure`.
7. Check that the default Azure file is `azure-pipelines/docs-site.yml`.
8. Check that the default trigger contains `azure-pipelines/docs-site.yml`.
9. Check that the custom Azure file is `ci/azure/docs-site.yml`.
10. Check that the custom trigger contains `ci/azure/docs-site.yml`.
11. Check that the custom configuration emits no file at the default Azure path.
12. Check that the custom pipeline contains no stale default trigger path.
13. Normalize only the trigger self-path in the default and custom pipeline text.
14. Check that the normalized pipeline text is byte-identical.
15. Check that the custom folder does not change a GitHub Actions path or file.
16. Check that GitHub Actions emits no Azure pipeline file.
17. Keep the existing docs-site evaluation checks.
18. Use the integration evaluation to check the central empty-folder rejection.
19. Keep the integration checks for all other invalid folder values.
20. Add no folder validation to the docs-site test fixture or composition.

## Check

Run these commands:

1. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
2. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`

Each command must exit with status zero. The docs-site result must expose a
true Boolean for each new folder check. The integration result must keep the
central folder validation checks true.

## Errors

- The docs-site evaluation must stop if a path or trigger result is wrong.
- The docs-site evaluation must stop if normalized pipeline bytes differ.
- The docs-site evaluation must stop if a custom folder changes GitHub Actions output.
- The integration evaluation must stop if it accepts an empty or invalid folder.
