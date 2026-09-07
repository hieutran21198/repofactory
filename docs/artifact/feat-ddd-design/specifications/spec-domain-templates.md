# spec-domain-templates: Define the domain artifacts

**Master:** [Specifications](README.md)
**Covers:** req-domain-model-artifacts, req-context-boundary-rule

## Description

The domain model of a project lives in `docs/domain/`. Each domain artifact has one template in
`docs/wiki/design/ddd/templates/domain/`. The artifacts use the same conventions as the feature
artifacts: no status field, no YAML front matter, bold key lines under the title, and tables.

## Contract

Directory structure:

    docs/domain/
        README.md                  The domain index and the core domain chart.
        context-map.md             The bounded contexts and their relationships.
        glossary.md                The ubiquitous language of each context.
        context-<name>/
            README.md              The bounded context canvas.
            agg-<name>.md          One aggregate canvas.

Names use lowercase letters, digits, and hyphens.

| Artifact | Template | Key lines | Sections |
| --- | --- | --- | --- |
| Domain index | `templates/domain/README.md` | - | Purpose. Core domain chart: table with Subdomain, Type, Bounded context, Why this type. Links to the context map, the glossary, and the contexts. |
| Context map | `templates/domain/context-map.md` | - | Contexts: table with Context, Purpose, Component. Relationships: table with Upstream, Downstream, Contract, Shared code. |
| Glossary | `templates/domain/glossary.md` | - | Terms: table with Term, Context, Meaning, Not the same as. |
| Bounded context canvas | `templates/domain/context-name/README.md` | `**Subdomain:**`, `**Type:** Core, Supporting, or Generic`, `**Component:** services/<name>` | Purpose. Ubiquitous language. Business rules. Inbound messages: table with Message, Kind, From. Outbound messages: table with Message, Kind, To. Aggregates. Assumptions. Open questions. |
| Aggregate canvas | `templates/domain/context-name/agg-name.md` | `**Context:** context-<name>`, `**Pattern:** Transaction script, Active record, Domain model, or Event-sourced domain model` | Description. State transitions: table with From, Command, To. Enforced invariants. Corrective policies: table with Event, Policy. Handled commands: table with Command, Result, Emits. Created events: table with Event, Payload. References by identity: table with Aggregate, Context. Notes. |

The `Kind` of a message is `command`, `query`, or `event`. The `Contract` of a relationship is
one of: Partnership, Shared kernel, Customer-supplier, Conformist, Anticorruption layer, Open
host service, Published language, Separate ways.

Boundary rule:

- One bounded context is implemented by one directory in `services/`.
- An application in `apps/` is a user interface over one or more contexts. It holds no domain
  rule.
- A library in `libs/` holds only a shared kernel or a published language.
- A context does not read the data store of another context.

## Errors

The design guide tells the user to leave a table row empty when a value is not known. It does
not tell the user to add a status.
