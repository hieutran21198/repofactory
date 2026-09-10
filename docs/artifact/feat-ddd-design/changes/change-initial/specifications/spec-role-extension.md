# spec-role-extension: Append the DDD chapter to a role

**Master:** [Specifications](README.md)
**Covers:** req-role-ddd-extension

## Description

The artifact-driven composition builds the instruction of each role from the base `ROLE.md`.
When `design.use` is `ddd`, it appends the DDD chapter of the role. The chapter is a second
authored file. The composition does not change the role option type.

## Contract

The composition module `services/factory/composition/artifact-driven/default.nix` computes the
instruction of a role `<name>` as follows:

```nix
instruction =
  builtins.readFile ./_assets/agent/role/<name>/ROLE.md
  + lib.optionalString (ddd && builtins.pathExists ./_assets/ddd/agent/role/<name>/ROLE.md)
      ("\n" + builtins.readFile ./_assets/ddd/agent/role/<name>/ROLE.md);
```

`ddd` is `design.use == "ddd"`. The DDD chapter files are:

- `_assets/ddd/agent/role/requirement-expert/ROLE.md`
- `_assets/ddd/agent/role/solution-expert/ROLE.md`

Each chapter starts with the heading `## Domain-Driven Design`. The role renderer puts the
full instruction into each harness in use. No harness gets a different chapter.

The requirement expert chapter adds these steps to phase 1: name the subdomain and its type;
find or make the bounded context and fill its purpose, language, business rules, assumptions,
and open questions; list the actors and the business events; add the terms to the glossary;
write the `## Domain` table of the master requirement; add `**Context:**` to each requirement.
It adds the rule: do not name an aggregate, a message, a component, or a pattern.

The solution expert chapter adds these steps to phase 2: fill the messages and the component of
each context; write one aggregate canvas for each aggregate; update the context map with the
contract between the contexts; write one decision that selects the implementation pattern; add
`**Context:**` and `**Aggregate:**` to each specification. It adds these rules to phase 3: one
task touches one bounded context; each task has `**Context:**`; the tasks of an upstream context
come before the tasks of its downstream context.

## Errors

The check fails if the instruction of a role differs from the base file when `design.use` is
not `ddd`.
The check fails if the instruction of a role is not the base file, one newline, and the chapter
file when `design.use` is `ddd`.
