# task-deploy-tool-option: Add the Static Web App deploy tool option

**Plan:** [Implementation plan](README.md)
**Covers:** req-swa-deploy-tool, spec-swa-deploy-tool
**Context:** context-factory

## Goal

Declare one deploy tool option and use it as the only selector for both Static Web App renderers.

## Files

- `services/factory/composition/artifact-driven/docs-site/default.nix`

## Steps

1. Open the docs-site options block in `default.nix`.
2. Declare option `azure-static-web-app.deploy-tool` with `_utils.mkEnumOpt`.
3. Accept only `official-task` and `swa-cli`.
4. Set the default to `official-task`.
5. Describe the option as the Static Web App upload mechanism.
6. Add an assertion that accepts only the two supported tools.
7. Use the full option path and both supported tools in the assertion message.
8. Make the selected scalar value available to both pipeline renderers.
9. Use this value as the only selector between the two deploy shapes.
10. Do not add a project option for the Static Web Apps CLI version.
11. Do not let this option change a `github-pages` pipeline.

## Check

Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.

- The existing checks pass with the default value.
- The evaluated option type contains only `official-task` and `swa-cli`.
- The evaluated option default is `official-task`.
- Both pipeline renderers read the same selected value.
- The project option tree contains no Static Web Apps CLI version option.

## Errors

An unsupported value must stop evaluation with this message:

`factory.composition.artifact-driven.docs-site.azure-static-web-app.deploy-tool must be "official-task" or "swa-cli"`
