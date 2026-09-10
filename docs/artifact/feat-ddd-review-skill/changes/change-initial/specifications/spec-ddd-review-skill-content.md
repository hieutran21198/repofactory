# spec-ddd-review-skill-content: Define the DDD review procedure

**Master:** [Specifications](README.md)
**Covers:** req-ddd-review-guidance
**Context:** context-factory

## Description

The `ddd-review` skill is self-contained guidance for a review of a generated project. It reads
only project files. It reports findings. It does not change an artifact, choose a model, or move
phase ownership.

## Contract

`SKILL.md` starts with this frontmatter:

```yaml
---
name: ddd-review
description: Review DDD artifacts, bounded context canvases, aggregate invariants, and artifact links. Use for "DDD review", "bounded context canvas", "aggregate invariants", or "DDD artifact links".
---
```

The body has these sections in this order:

| Section | Required content |
| --- | --- |
| `## When to use` | The skill reviews existing DDD artifacts. It does not write or change them. |
| `## Read first` | The DDD guide, phase mapping, selected repository architecture guide, domain artifacts, and feature artifacts in scope. |
| `## Procedure` | The review steps. |
| `## Checks` | The strategic, tactical, and feature-artifact checks below. |
| `## Report` | The required finding format and phase owners. |
| `## Rules` | The review-only and ownership limits. |

The procedure reads the files, identifies the selected architecture, checks only artifacts in
scope, reports each finding, and reports no finding when all checks pass.

The checks include:

- A context canvas has its strategic fields. Its `**Component:**` path is under `services/` for
  the multiple architecture and under `src/` for the single architecture.
- An aggregate canvas belongs to an existing context. Its invariants define a consistency boundary.
  It references another aggregate by identity only. A cross-aggregate state change uses an event
  and a policy.
- A context-map relationship has a valid contract. A feature artifact that names a context or an
  aggregate names an existing domain artifact.
- A requirement artifact has only a context link. A specification artifact can have an aggregate
  link. A task has one context. The task order puts an upstream context before a downstream context.
- The glossary uses one meaning for one term in one context.

Each finding has the artifact path, the failed rule, evidence, and the owner: the requirement
expert for phase 1, or the solution expert for phases 2 and 3.

## Errors

Nix evaluation fails when the skill has no required frontmatter or omits a required review topic,
architecture path, review-only rule, or phase owner.
