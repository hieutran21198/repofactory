# spec-docs-site-workflow: Publish the site with typed build extensions

**Master:** [Specifications](README.md)
**Covers:** req-github-pages-publishing, req-generated-assets, req-azure-static-web-app
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The generated GitHub Actions workflow builds the website and publishes it to the selected target. The
factory owns the trigger, build, deployment, and notification steps. A downstream repository adds
watch paths and build steps through typed options. The target contract is in
[spec-azure-static-web-app](spec-azure-static-web-app.md).

## Contract

### Watch paths

The push trigger contains these paths first:

```yaml
- docs/**
- apps/documentation/**
- .github/workflows/docs-site.yml
```

The renderer writes `workflow.watch-paths` after these paths and keeps the configured order. It
JSON-encodes each added path as a YAML scalar. Each generated list line starts with six spaces,
which is the same final indentation as a factory path. The manual trigger does not change. The
trigger does not change per target.

### Build step order

The build job uses this order on both targets:

1. Check out the repository.
2. Run `workflow.build.before-node-setup` in list order.
3. Set up Node.js 22.
4. Run `npm ci` in `apps/documentation`.
5. Run `workflow.build.before-site-build` in list order.
6. Run `npm run build` in `apps/documentation`.
7. Run `workflow.build.after-site-build` in list order.
8. Publish `apps/documentation/build` to the selected target.

The job keeps `defaults.run.working-directory: apps/documentation`. A custom run step inherits this
value unless it sets `working-directory`. A step failure stops later steps and prevents deployment.

### Target branch

With `target = "github-pages"`, the workflow keeps the version 5.0.0 shape: an upload step with
`actions/upload-pages-artifact@v3` and a deploy job with `actions/deploy-pages@v4`, the
`github-pages` environment, and the `pages: write` and `id-token: write` permissions.

With `target = "azure-static-web-app"`, the workflow uploads `apps/documentation/build` with
`Azure/static-web-apps-deploy@v1`, `app_location: apps/documentation/build`,
`output_location: build`, and `skip_app_build: true`. The token input reads
`${{ secrets.<api-token-secret> }}`. The workflow emits no Pages deploy job,
no `github-pages` environment, and no `pages: write` permission. The
notification step follows the deploy step.

With `skip_app_build: true`, the deploy action ignores `output_location`.
It reads the app artifacts directly from `app_location`. The composition
keeps `output_location: build` only for shape-compatibility.

### Step rendering

The renderer writes one YAML list item for each typed step. It supports only `name`, `uses`, `with`,
`run`, `env`, and `working-directory`. It JSON-encodes scalar values and map values. YAML accepts
these JSON scalar forms. This rule protects punctuation, expressions, and multiline run strings.

A Nix configuration quotes the attribute name as `"with"`. The generated YAML uses the unquoted
GitHub Actions field name `with`.

The renderer omits empty `with` and `env` maps. It does not combine or reorder configured steps.

### Unchanged behavior

The build condition, concurrency, and notification inputs do not
change. Empty extension lists add no watch path and no build step. With `target = "github-pages"`
and empty extension lists, the generated workflow keeps the version 5.0.0 shape.

## Errors

An invalid typed value stops Nix module evaluation. An invalid step relation produces a false
assertion. An invalid target or token secret name produces a false assertion. A custom step that exits with a nonzero status stops the build before deployment.
