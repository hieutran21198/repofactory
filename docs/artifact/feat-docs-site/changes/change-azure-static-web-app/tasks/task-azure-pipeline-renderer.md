# task-azure-pipeline-renderer: Branch the Azure pipeline renderer per target

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, spec-docs-site-azure-pipeline, spec-azure-static-web-app
**Context:** context-factory

## Goal

Render `azure-pipelines/docs-site.yml` for the selected target in `default.nix`.

## Steps

1. Open the `azurePipeline` renderer in `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Keep the trigger, the Node.js 22 build, the three typed build hooks, and the watch paths the same on both targets.
3. Keep the `gh-pages` publish shape when `target` is `"github-pages"`.
4. Keep the need for `DOCS_SITE_GITHUB_TOKEN` only on the `github-pages` target.
5. Add the Static Web App branch when `target` is `"azure-static-web-app"`.
6. Deploy with task `AzureStaticWebApp@0` (`@0` is the current task version).
7. Set `app_location` to `apps/documentation`.
8. Set `output_location` to `build`.
9. Set `skip_app_build` to `true`.
10. Read the token from `$(<api-token-secret>)`.
11. Run the task after `npm run build` and after `workflow.build.after-site-build`.
12. Emit no `gh-pages` publish step on the Static Web App target.
13. Map each secret name one to one onto an Azure secret variable with the same name.
14. Run the same notifier `.github/docs-site/notify.py` after a successful deployment on both targets.
15. Use the configured site URL as the deployment URL on the Static Web App target.

## Check

Evaluate `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` with `nix-instantiate --eval --strict`.

- With the default target, the pipeline keeps the `gh-pages` publish shape and emits no Static Web App content.
- With `azure-static-web-app`, the pipeline uses `AzureStaticWebApp@0` with the three location inputs and the configured token secret.
- With `azure-static-web-app`, the pipeline emits no `gh-pages` publish step.
- Extension steps keep their points and order on both targets.
- The notifier path and its bytes match the GitHub selection.
