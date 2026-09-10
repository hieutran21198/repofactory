# adr-role-extension-mechanism: Append a second file to the role instruction

**Relates to:** spec-role-extension

## Context

The instruction of a role is one string option. Two modules cannot both define it. The DDD
steps must reach the roles only when the project selects DDD.

## Options

1. Append a second authored file in the composition module. Pro: no option change, no
   duplicate text, the base file stays the source of truth. Con: the seam is a string
   concatenation in the composition.
2. Force a full DDD variant of each `ROLE.md`. Pro: each variant is one readable file. Con: the
   base text exists two times and the two copies drift.
3. Change the option type to lines and add the chapter from a separate module. Pro: idiomatic
   module merge. Con: a wider change to the role module for one extension.

## Decision

Append a second authored file in the composition module.
The composition already combines the documentation model with the other domains.

## Consequences

The DDD chapter is one file per role under `_assets/ddd/agent/role/`.
A later extension that needs a merge from a separate module must revisit the option type.
