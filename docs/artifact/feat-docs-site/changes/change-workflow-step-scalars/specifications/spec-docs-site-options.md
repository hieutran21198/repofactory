# spec-docs-site-options: Declare the docs-site composition options

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-generated-assets
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The composition sub-module declares `factory.composition.artifact-driven.docs-site`. The option is
off by default. When it is on, the module checks the selected domains, site values, notification
values, and workflow step shapes.

The module declares one private `workflowStepModule`. A list option uses
`lib.types.submodule workflowStepModule` as its element type. The existing builders in
`factory._utils` are sufficient. The change does not add a shared option builder.

## Contract

### Site and workflow options

| Option | Type | Default | Meaning |
| --- | --- | --- | --- |
| `enable` | `bool` | `false` | Render the site and workflow. |
| `title` | `str` | `"Documentation"` | Set the browser and navbar title. |
| `url` | `str` | `""` | Set the website origin. |
| `base-url` | `str` | `"/"` | Set the website path below its origin. |
| `static-directories` | `listOf str` | `[]` | Set Docusaurus static directories relative to `apps/documentation/`. |
| `workflow.watch-paths` | `listOf str` | `[]` | Add paths to the push trigger after the factory paths. |
| `workflow.build.before-node-setup` | `listOf workflowStep` | `[]` | Add steps after checkout and before Node.js setup. |
| `workflow.build.before-site-build` | `listOf workflowStep` | `[]` | Add steps after dependency install and before the site build. |
| `workflow.build.after-site-build` | `listOf workflowStep` | `[]` | Add steps after the site build and before artifact upload. |

The notification option tree and its defaults do not change.

### Workflow step type

| Field | Type | Default | Rule |
| --- | --- | --- | --- |
| `name` | optional `str` | absent | Set the displayed step name. |
| `uses` | optional `str` | absent | Select one action. It cannot occur with `run`. |
| `with` | `attrsOf workflowScalar` | `{}` | Set action inputs. It needs `uses`. |
| `run` | optional `str` | absent | Run one command or script. It cannot occur with `uses`. |
| `env` | `attrsOf workflowScalar` | `{}` | Set environment variables for the step. |
| `working-directory` | optional `str` | absent | Override the job default for a run step. It needs `run`. |

Nix configurations write the `with` field as `"with"` because `with` is a Nix keyword.

`workflowScalar` is `oneOf [ str bool int float ]`. The renderer uses `builtins.toJSON` for each
value. Thus, strings stay strings, Booleans stay Booleans, and numbers stay numbers in YAML.

The four optional string options use `nullable = true` and `default = null`. The Nix module system
then gives each field a safe value when a project omits it. The renderer omits a field when its
value is null. The validator checks a string only when its value is not null.

The renderer omits absent fields and empty maps. It keeps list order. It writes fields in the table
order and map keys in Nix attribute order.

### Assertions

The existing site and notification assertions do not change. The module adds these assertions when
the site is enabled:

- Each static directory and watch path is not an empty string.
- Each workflow step has exactly one non-empty `uses` or `run` value.
- A non-empty `with` map occurs only on a `uses` step.
- `working-directory` occurs only on a `run` step and is not empty.

All hook lists use the same assertions. The error message names the docs-site option group and the
invalid rule.

## Errors

The Nix module system rejects a list element or step field with the wrong type. An assertion stops
evaluation for an invalid path or step relation. When `enable` is `false`, the module emits no file
and no assertion.
