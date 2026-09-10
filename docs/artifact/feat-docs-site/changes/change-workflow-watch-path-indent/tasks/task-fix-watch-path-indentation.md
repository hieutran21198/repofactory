# task-fix-watch-path-indentation: Fix generated watch path indentation

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-docs-site-workflow
**Context:** context-factory

## Goal

Render a configured watch path as a valid YAML item under `push.paths`.

## Steps

1. Change the interpolated path prefix from twelve spaces to six spaces.
2. Add an exact-line evaluation check for one configured watch path.
3. Check that the old twelve-space line is absent.
4. Run the docs-site evaluation and a real module evaluation.

## Check

The generated workflow contains this line:

```yaml
      - "services/manual/docs/**"
```

It does not contain the same path with twelve leading spaces.
