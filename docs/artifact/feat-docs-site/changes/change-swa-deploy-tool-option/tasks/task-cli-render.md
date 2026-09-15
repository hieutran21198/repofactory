# task-cli-render: Render the pinned Static Web Apps CLI deploy shape

**Plan:** [Implementation plan](README.md)
**Covers:** req-swa-cli-pinned, spec-swa-cli-deploy
**Context:** context-factory

## Goal

Render the selected deploy shape for both CI providers with one factory-owned Static Web Apps CLI pin.

## Files

- `services/factory/composition/artifact-driven/docs-site/default.nix`

## Steps

1. Open the GitHub Actions and Azure Pipelines renderers in `default.nix`.
2. Keep `@azure/static-web-apps-cli` version `2.0.10` as a factory-owned pin.
3. Keep the version 6.1.0 official action and task when the tool is `official-task`.
4. Emit no CLI installation or CLI deploy step for `official-task`.
5. Keep the current `actions/setup-node@v4` npm cache inputs for the GitHub workflow.
6. For GitHub `swa-cli`, add the CLI installation after the build and all after-build steps.
7. Add the GitHub CLI deploy step after the installation step.
8. Run both GitHub steps from `apps/documentation` through the existing job default.
9. Map the configured GitHub secret to `SWA_CLI_DEPLOYMENT_TOKEN` on the deploy step.
10. For Azure `swa-cli`, set `npm_config_cache` to `$(Pipeline.Workspace)/.npm`.
11. Add `Cache@2` after `NodeTool@0` and before `npm ci` only for `swa-cli`.
12. Set the cache key to `"npm" | "$(Agent.OS)" | "swa-cli-2.0.10" | apps/documentation/package-lock.json`.
13. Restore from `"npm" | "$(Agent.OS)" | "swa-cli-2.0.10"` and then `"npm" | "$(Agent.OS)"`.
14. Set the cache path to `$(npm_config_cache)`.
15. Add the Azure CLI installation after the build and all after-build steps.
16. Add the Azure CLI deploy script after the installation script.
17. Set `workingDirectory` to `apps/documentation` on both Azure scripts.
18. Map the configured Azure secret variable to `SWA_CLI_DEPLOYMENT_TOKEN` on the deploy script.
19. Install the CLI with `npm install --global @azure/static-web-apps-cli@2.0.10` on both providers.
20. Deploy with `swa deploy ./build --deployment-token "$SWA_CLI_DEPLOYMENT_TOKEN" --env production` on both providers.
21. Emit no official Static Web App action or task for `swa-cli`.
22. Keep the notification step after the selected deploy shape without a content change.
23. Keep hooks, extension points, build output, token names, and `github-pages` pipelines unchanged.

## Check

Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.

- Each provider keeps its official deploy shape for `official-task`.
- Each provider emits only the two CLI steps for `swa-cli`.
- Both providers install version `2.0.10` and run the common deploy command.
- The GitHub workflow uses the existing npm cache.
- The Azure pipeline emits the specified npm cache variable and `Cache@2` task.
- The order is build hooks, installation, deployment, and notification.
- A `github-pages` pipeline emits no Static Web App deploy content.

## Errors

- A failed CLI installation stops the deploy step.
- A missing or invalid deployment token fails the deploy step.
- A failed deployment stops the notification step.
- The generated pipeline must not write the deployment token to a log.
