# adr-canonical-role-source: Use one role source

**Relates to:** spec-harness-delivery
**Context:** context-factory

## Context

The artifact master must give the same coordination and message contract in each harness. The factory supports a role renderer and a delegating skill.

## Options

1. Use one canonical role body and render it for each harness. Pro: One contract has one source. Con: The role body must use shared terms.
2. Write one complete role body for each harness. Pro: Each body can use harness-specific words. Con: The bodies can diverge.

## Decision

Select option 1. The canonical role body is the source of the coordination and message contract. The skill only loads the rendered role for the harness in use.

## Consequences

The factory can test one source and each rendered result. A harness-specific need must stay in its declaration or its thin skill instructions.
