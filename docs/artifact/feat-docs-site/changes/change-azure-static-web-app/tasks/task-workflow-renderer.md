# task-workflow-renderer: Branch the GitHub workflow renderer per target

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, spec-docs-site-workflow, spec-azure-static-web-app
**Context:** context-factory

## Goal

Render `.github/workflows/docs-site.yml` for the selected target in `default.nix`.

## Steps

1. Open the `workflow` renderer in `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Keep the trigger, the Node.js 22 build, the three typed build hooks, and the watch paths the same on both targets.
3. Keep the version 5.0.0 shape when `target` is `"github-pages"`.
4. Keep the upload step with `actions/upload-pages-artifact@v3`.
5. Keep the deploy job with `actions/deploy-pages@v4`.
6. Add the Static Web App branch when `target` is `"azure-static-web-app"`.
7. Deploy with `Azure/static-web-apps-deploy@v1` (`v1` is the latest marketplace tag).
8. Set `app_location` to `apps/documentation`.
9. Set `output_location` to `build`.
10. Set `skip_app_build` to `true`.
11. Read the token from `${{ secrets.<api-token-secret> }}`.
12. Run the deploy step after `npm run build` and after `workflow.build.after-site-build`.
13. Emit no Pages deploy job, no `github-pages` environment, and no `pages: write` permission on the Static Web App target.
14. Run the same notifier after a successful deployment on both targets.
15. Use the configured site URL (`url` plus `base-url`) as the deployment URL on the Static Web App target.

## Check

Evaluate `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` with `nix-instantiate --eval --strict`.

- With the default target, the workflow keeps the version 5.0.0 shape and emits no Static Web App content.
- With `azure-static-web-app`, the workflow uses `Azure/static-web-apps-deploy@v1` with the three location inputs and the configured token secret.
- With `azure-static-web-app`, the workflow emits no GitHub Pages publish content.
- Extension steps keep their points and order on both targets.
- `site.json` bytes are identical on both targets for the same site values.
