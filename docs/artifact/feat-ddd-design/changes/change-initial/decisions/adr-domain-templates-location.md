# adr-domain-templates-location: Keep the domain templates in a DDD-owned tree

**Relates to:** spec-ddd-files, spec-domain-templates

## Context

The artifact-driven module emits its templates as one directory copy. The DDD module must not
depend on the documentation model. The domain templates need a location.

## Options

1. Put the templates in `docs/wiki/design/ddd/templates/domain/`, emitted by the DDD module.
   Pro: the DDD module is complete on its own, no directory collision. Con: two template
   trees in the wiki.
2. Put the templates in `docs/wiki/documentation/artifact-driven/templates/domain/`. Pro: one
   template tree. Con: a second module cannot add a folder to a directory copy, and the
   documentation module must then know about design.

## Decision

Put the templates in `docs/wiki/design/ddd/templates/domain/`.

## Consequences

The design guide and the templates live in one directory. A project can use DDD without the
artifact-driven documentation model.
