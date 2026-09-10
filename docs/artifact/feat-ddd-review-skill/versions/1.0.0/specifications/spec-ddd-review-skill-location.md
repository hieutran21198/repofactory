# spec-ddd-review-skill-location: Register the shared skill

**Master:** [Specifications](README.md)
**Covers:** req-ddd-review-skill-shipped, req-ddd-review-skill-selection
**Context:** context-factory

## Description

The artifact-driven composition registers the `ddd-review` folder as a general agent skill. The
agent skill domain module already renders each general skill into every harness in use. The
composition adds the entry only when the documentation model is artifact-driven, the design method
is DDD, and the repository architecture is `multiple` or `single`.

## Contract

The source folder is:

```text
services/factory/composition/artifact-driven/_assets/agent/skill/ddd-review/
└── SKILL.md
```

The composition adds this configuration in a conditional block:

```nix
${namespace}.domain.agent.skill.general.ddd-review = ./_assets/agent/skill/ddd-review;
```

The condition is `documentation.use == model && ddd && repo-arch.use != ""`. The entry is not
in `by-role/`, because it is one shared skill and does not change the body or ownership of an
expert role.

The existing agent skill domain module renders the folder with `copyMode = "copy"`:

| Harness in `factory.domain.agent.harness.uses` | Target |
| --- | --- |
| `claude` | `.claude/skills/ddd-review/` |
| `codex`, `opencode`, or both | `.agents/skills/ddd-review/` |

## Errors

Nix evaluation fails when a DDD configuration with a repository architecture has no `ddd-review`
entry. It also fails when a configuration without the documentation model, DDD, or an architecture
has the entry.
