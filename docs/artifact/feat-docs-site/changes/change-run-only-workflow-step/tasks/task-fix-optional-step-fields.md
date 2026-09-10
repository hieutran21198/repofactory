# task-fix-optional-step-fields: Fix optional workflow step fields

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-docs-site-options
**Context:** context-factory

## Goal

Let the module evaluate and render a valid workflow step that has only `run` or only `uses`.

## Steps

1. Give each optional string option a null default.
2. Check optional fields by their values instead of attribute presence.
3. Render only optional fields that have non-null values.
4. Update the stub option builder to apply nullable defaults.
5. Add explicit `run`-only and `uses`-only regression checks.
6. Run the docs-site evaluation and formatting checks.

## Check

The evaluation renders both valid step forms. It rejects steps with both command fields or neither
command field.
