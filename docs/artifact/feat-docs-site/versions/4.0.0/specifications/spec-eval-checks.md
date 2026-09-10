# spec-eval-checks: Check typed docs-site extensions

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, req-generated-assets
**Context:** context-factory

## Description

The standalone Nix evaluation imports the docs-site module with a stub library. It checks the
generated files, option metadata, workflow variants, notifications, and assertions. Python tests
continue to check notifier behavior.

## Contract

The evaluation adds an `extensions` configuration. It uses two static directories, one watch path,
an action step before Node.js setup, a run step before the site build, and a run step after the site
build. Together, the steps use all six supported fields.

The evaluation checks these results:

- All five extension option defaults are empty lists.
- Each hook uses the same workflow step submodule.
- The step submodule declares the six fields with their specified types and defaults.
- Default `site.json` contains `staticDirectories = []`.
- Extended `site.json` keeps static directory order.
- The Docusaurus configuration reads `site.staticDirectories`.
- The extended watch path follows the three factory paths.
- Each custom step occurs at its specified point and list order is stable.
- YAML output contains the configured `name`, `uses`, `with`, `run`, `env`, and
  `working-directory` values.
- Empty extension lists add no custom workflow content.
- Invalid paths and invalid step relations produce false assertions.
- Existing file, dependency, notification, disabled-state, and domain-selection checks still pass.

The test stub adds the minimum `types`, `mkAttrsOpt`, string concatenation, and attribute helpers
that the production module uses. It does not duplicate the Nix module system.

## Commands

Run the module evaluation:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix
```

Run the notifier regression tests:

```sh
python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py
```

Build the self-hosted website with Node.js 22 after the evaluation passes.

## Errors

The Nix command stops if a Boolean check is false or a source file is absent. The Python command
reports each failed notifier test and exits with a nonzero status.
