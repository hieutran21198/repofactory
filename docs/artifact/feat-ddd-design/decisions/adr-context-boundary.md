# adr-context-boundary: One bounded context is one service

**Relates to:** spec-domain-templates

## Context

The repository architecture defines components as directories. DDD defines bounded contexts as
model boundaries. The two must map to each other.

## Options

1. One bounded context is one directory in `services/`. Applications are user interfaces over
   one or more contexts. Libraries hold only a shared kernel or a published language. Pro: one
   clear rule, the model boundary and the deployment boundary are the same. Con: a small
   context is one more service.
2. One bounded context is one or more components, listed in the context canvas. Pro:
   flexible. Con: no rule to check, a context can spread over many directories.
3. No rule. Pro: each project decides. Con: the agents cannot tell which directory owns a rule.

## Decision

One bounded context is one directory in `services/`.

## Consequences

The bounded context canvas has one `**Component:**` line with the value `services/<name>`.
A shared kernel or a published language is a library in `libs/`.
