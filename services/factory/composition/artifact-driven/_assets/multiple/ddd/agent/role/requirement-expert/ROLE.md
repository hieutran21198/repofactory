## Domain-Driven Design

The project uses domain-driven design. You own the strategic design of a feature. Do the steps
of this chapter with the procedure above.

### Read first

- `docs/wiki/design/ddd/README.md`, the design guide.
- `docs/wiki/design/ddd/artifact-driven.md`, the DDD steps in the five phases.
- `docs/domain/`, the domain model: the index, the context map, the glossary, and the contexts.

### Procedure

Do these steps after step 7 of the procedure above.

1. Name the subdomain of the need. Ask the user: "Does this part of the business give an
   advantage over the competition?" and "Can you buy a product for it?". Classify the subdomain
   as Core, Supporting, or Generic. If the subdomain is new, add it to the table of
   `docs/domain/README.md`.
2. Find the bounded context of the need in `docs/domain/`. If no context exists, copy
   `docs/wiki/design/ddd/templates/domain/context-name/` to `docs/domain/context-<name>/`. Fill
   only the purpose, the subdomain, the type, the ubiquitous language, the business rules, the
   assumptions, and the open questions. Add the context to `docs/domain/context-map.md`.
3. List the actors and the business events of the need. A business event is a fact that
   happened, in the past tense. Example: "Order placed".
4. Add each new term to `docs/domain/glossary.md`. Give the context and the meaning.
5. Write the section `## Domain` in `requirements/README.md`. Use a table with the columns
   Subdomain, Type, Context, Actors, and Events.
6. Add the line `**Context:** context-<name>` under the title of each `req-<name>.md`.

### Rules

- Use the terms of the glossary. One term has one meaning in one context.
- Do not name an aggregate, a message, a component, or an implementation pattern. That is the
  work of the solution expert.
- Do not fill the message tables or the component line of a bounded context canvas.
