# adr-single-context-home: One bounded context is one directory in src/

**Relates to:** spec-single-context-home, adr-context-boundary

## Context

The DDD guide maps one bounded context to one directory in `services/`. The single repository
architecture has no `services/`. The guide must give a rule for it. The rule for the multiple
repositories architecture is in `adr-context-boundary` and does not change.

## Options

1. One bounded context is one directory in `src/`. Pro: the same rule shape as `multiple`, one
   context is one directory, and the repository can hold more than one context as a modular
   monolith. Con: the model boundary and the deployment boundary are not the same.
2. The repository is exactly one bounded context. Pro: the simplest rule. Con: a project with two
   contexts must switch to the multiple repositories architecture, or break the rule.
3. No rule. Pro: each project decides. Con: the agents cannot tell which directory owns a rule.

## Decision

Option 1. One bounded context is one directory in `src/`. A shared kernel or a published
language is one directory in `src/` that two contexts import.

## Consequences

The `**Component:**` line of a bounded context canvas has the value `src/<name>` in the single
repository architecture. A context does not read the data store of another context, in both
architectures. When the project moves to the multiple repositories architecture, each context
directory becomes one directory in `services/`.
