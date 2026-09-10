# spec-docs-site-workflow: Publish the site with typed build extensions

**Master:** [Specifications](README.md)
**Covers:** req-github-pages-publishing, req-generated-assets
**Context:** context-factory

## Description

The generated GitHub Actions workflow builds the website and publishes it to GitHub Pages. The
factory owns the trigger, build, deployment, and notification steps. A downstream repository adds
watch paths and build steps through typed options.

## Contract

### Watch paths

The push trigger contains these paths first:

```yaml
- docs/**
- apps/documentation/**
- .github/workflows/docs-site.yml
```

The renderer writes `workflow.watch-paths` after these paths and keeps the configured order. It
JSON-encodes each added path as a YAML scalar. The manual trigger does not change.

### Build step order

The build job uses this order:

1. Check out the repository.
2. Run `workflow.build.before-node-setup` in list order.
3. Set up Node.js 22.
4. Run `npm ci` in `apps/documentation`.
5. Run `workflow.build.before-site-build` in list order.
6. Run `npm run build` in `apps/documentation`.
7. Run `workflow.build.after-site-build` in list order.
8. Upload `apps/documentation/build`.

The job keeps `defaults.run.working-directory: apps/documentation`. A custom run step inherits this
value unless it sets `working-directory`. A step failure stops later steps and prevents deployment.

### Step rendering

The renderer writes one YAML list item for each typed step. It supports only `name`, `uses`, `with`,
`run`, `env`, and `working-directory`. It JSON-encodes scalar values and map values. YAML accepts
these JSON scalar forms. This rule protects punctuation, expressions, and multiline run strings.

A Nix configuration quotes the attribute name as `"with"`. The generated YAML uses the unquoted
GitHub Actions field name `with`.

The renderer omits empty `with` and `env` maps. It does not combine or reorder configured steps.

### Unchanged behavior

The build condition, permissions, concurrency, deployment job, and notification steps do not
change. Empty extension lists add no watch path and no build step. In this state, the generated
workflow text is the same as version 3.0.0.

## Errors

An invalid typed value stops Nix module evaluation. An invalid step relation produces a false
assertion. A custom step that exits with a nonzero status stops the build before Pages deployment.
