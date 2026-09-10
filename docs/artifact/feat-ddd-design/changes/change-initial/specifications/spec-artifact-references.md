# spec-artifact-references: Point a feature artifact to a domain artifact

**Master:** [Specifications](README.md)
**Covers:** req-domain-model-artifacts

## Description

A feature artifact points to the domain artifacts that it uses. The pointer is a bold key line
under the title, in the same style as `**Master:**` and `**Covers:**`. The feature templates do
not change. The phase-mapping page gives the rule.

## Contract

| Artifact | Key line | Value |
| --- | --- | --- |
| `requirements/README.md` | Section `## Domain` | A table with Subdomain, Type, Context, Actors, Events. |
| `req-<name>.md` | `**Context:**` | `context-<name>`, or a comma-separated list. |
| `spec-<name>.md` | `**Context:**` | `context-<name>`. |
| `spec-<name>.md` | `**Aggregate:**` | `agg-<name>`, or a comma-separated list. Present only if the specification changes an aggregate. |
| `task-<name>.md` | `**Context:**` | `context-<name>`. One context per task. |
| `adr-<name>.md` | `**Context:**` | `context-<name>`, or `domain` for a decision that changes the context map. |

The value of `**Context:**` is the name of a folder in `docs/domain/`. The value of
`**Aggregate:**` is the name of a file in that folder without `.md`.

## Errors

The solution expert reports a specification that names a context that does not exist in
`docs/domain/`.
