## Domain-Driven Design

The project uses domain-driven design. You own the tactical design of a feature. Do the steps
of this chapter with the procedures above.

### Read first

- `docs/wiki/design/ddd/README.md`, the design guide.
- `docs/wiki/design/ddd/artifact-driven.md`, the DDD steps in the five phases.
- `docs/domain/`, and the canvas of each context that the requirements name.

### Procedure: phase 2, specifications

Do these steps after step 2 of the phase 2 procedure above.

1. For each context that the feature touches, fill the inbound messages, the outbound
   messages, and the `**Component:**` line of `docs/domain/context-<name>/README.md`. The
   component is one directory in `services/` in the multiple repositories architecture, or one
   directory in `src/` in the single repository architecture.
2. Find the aggregates. Put in one aggregate only the data that one business rule must keep
   consistent in one transaction. Write one `docs/domain/context-<name>/agg-<name>.md` for each
   aggregate. Give the invariants, the state transitions, the handled commands, the created
   events, and the references by identity.
3. Write one policy for each rule of the form "when this event, then this command". Put it in
   the corrective policies table of the aggregate that handles the command.
4. Update `docs/domain/context-map.md` with the contract between each pair of contexts that
   communicate. Put a shared kernel or a published language in `libs/<name>` in the multiple
   repositories architecture, or in `src/<name>` in the single repository architecture.
5. Write one `decisions/adr-<name>.md` that selects the implementation pattern of each
   aggregate. Use the table "Select the implementation pattern" of the design guide. Give the
   pattern in the `**Pattern:**` line of the aggregate canvas.
6. Add the line `**Context:** context-<name>` under the title of each `spec-<name>.md`. Add the
   line `**Aggregate:** agg-<name>` when the specification changes an aggregate.

### Procedure: phase 3, implementation plan

- One task touches one bounded context. Split a task that touches two contexts.
- Add the line `**Context:** context-<name>` under the title of each `task-<name>.md`.
- Put the tasks of an upstream context before the tasks of its downstream context.

### Rules

- One bounded context is one directory in `services/` in the multiple repositories
  architecture, or one directory in `src/` in the single repository architecture. An
  application holds no domain rule. A library holds only a shared kernel or a published language.
- A context does not read the data store of another context.
- Reference another aggregate by identity only.
- Use the terms of the glossary. Report a specification that names a context that does not
  exist in `docs/domain/`.
