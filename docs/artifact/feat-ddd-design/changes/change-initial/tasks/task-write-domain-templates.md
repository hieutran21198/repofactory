# task-write-domain-templates: Write the domain templates

**Plan:** [Implementation plan](README.md)
**Covers:** req-domain-model-artifacts, spec-domain-templates

## Goal

Each domain artifact has one template in `docs/wiki/design/ddd/templates/domain/`.

## Steps

1. Write `README.md`, `context-map.md`, and `glossary.md` in the templates directory.
2. Write `context-name/README.md` with the key lines and the sections of the bounded context
   canvas.
3. Write `context-name/agg-name.md` with the key lines and the sections of the aggregate canvas.
4. Review the text with the `asd-ste-100` skill.

## Check

Each template has the key lines and the sections of the table in `spec-domain-templates`. No
template has a status field or YAML front matter.
