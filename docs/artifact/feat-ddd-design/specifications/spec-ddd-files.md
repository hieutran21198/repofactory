# spec-ddd-files: Define the DDD files

**Master:** [Specifications](README.md)
**Covers:** req-ddd-guidance, req-domain-model-artifacts

## Description

The module `services/factory/domain/design/ddd/default.nix` emits the design guide, the domain
templates, and the seeds of the domain model. The module knows nothing about the documentation
model.

## Contract

When `design.use` is `ddd`, the module adds these file declarations:

| Target | Source | Copy mode |
| --- | --- | --- |
| `docs/wiki/design/ddd/README.md` | `_assets/docs/wiki/design/ddd/README.md` | `copy` |
| `docs/wiki/design/ddd/templates` | `_assets/docs/wiki/design/ddd/templates` | `copy` |
| `docs/domain/README.md` | `_assets/docs/domain/README.md` | `seed` |
| `docs/domain/context-map.md` | `_assets/docs/domain/context-map.md` | `seed` |
| `docs/domain/glossary.md` | `_assets/docs/domain/glossary.md` | `seed` |

The `copy` mode overwrites the target on each shell entry. The `seed` mode writes the target
one time and keeps the edits of the user.

The module does not seed a bounded context folder. The user copies the template when a context
exists.

The design guide `docs/wiki/design/ddd/README.md` has these sections, in this order:

1. Purpose, with the rule "do the strategic design before the tactical design".
2. Strategic design: subdomain types, bounded context, ubiquitous language, context map with
   the relationship table.
3. Tactical design: aggregate with the four rules, entity, value object, domain event, command,
   policy, domain service, application service, repository.
4. Where a context lives: the boundary rule of `spec-domain-templates`.
5. Select the implementation pattern: the table below, and the rule to record the selection in
   a decision.
6. The domain model: the directory structure of `docs/domain/` and the artifact table.
7. Procedure: add a bounded context.

| Subdomain type | Business logic | Pattern |
| --- | --- | --- |
| Generic | Adopt an existing product. | Transaction script for the integration. |
| Supporting | Simple rules. | Active record, or transaction script if there is no rule. |
| Core | Complex rules and invariants. | Domain model. |
| Core | Complex rules, and the history of each change has business value. | Event-sourced domain model. |

## Errors

Nix evaluation fails if a source path does not exist.
The check fails if the module emits a file when `design.use` is not `ddd`.
