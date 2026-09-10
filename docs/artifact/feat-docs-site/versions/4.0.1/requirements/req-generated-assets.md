# req-generated-assets: Publish generated documentation assets

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The docs-site composition must give a downstream repository typed options for static directories,
workflow watch paths, and workflow build steps. The factory must keep ownership of
`docusaurus.config.js` and `.github/workflows/docs-site.yml`.

The workflow must let the repository add steps before Node.js setup, before the site build, and
after the site build. A step must support `name`, `uses`, `with`, `run`, `env`, and
`working-directory`.

## Acceptance criteria

- Given a configured static directory, when Docusaurus builds the site, then the published site contains the files in that directory.
- Given more workflow watch paths, when a push changes one of those paths, then the docs-site workflow starts.
- Given configured build steps, when the workflow runs, then each step runs at its configured extension point and in list order.
- Given an action step, when evaluation runs, then the step accepts `name`, `uses`, `with`, and `env` values with their declared types.
- Given a command step, when evaluation runs, then the step accepts `name`, `run`, `env`, and `working-directory` values with their declared types.
- Given an invalid step shape, when evaluation runs, then evaluation stops before it generates an invalid workflow.
- Given no extension values, when the factory generates the site and workflow, then the site build and deployment behavior do not change.
- Given typed extension values, when the factory generates the repository, then the downstream repository does not replace either factory-owned file.

## Notes

Static directory paths are relative to `apps/documentation/`. Run steps inherit the build job
working directory unless they set `working-directory`.
