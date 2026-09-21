# adr-repository-blueprint-pattern: Keep the domain model pattern

**Relates to:** spec-ux-design-option, spec-design-tool, spec-designer-expert, spec-phase-placement
**Context:** context-factory

## Context

The Repository blueprint aggregate enforces related rules for options, roles, harnesses, files,
and workflow output. UX Design adds conditional rules across all these items.

## Options

1. Keep the Domain model pattern. Pro: The aggregate can enforce the related UX Design invariants
   together. Con: The model needs explicit invariants and events.
2. Use a transaction script. Pro: The composition action is direct. Con: Related option, role,
   harness, and file rules can spread across scripts.

## Decision

Select option 1. Keep the Domain model pattern because one Repository blueprint must keep all UX
Design selections and generated outputs consistent.

Use a Boolean option that renders no file. Use conditional composition output when the option is
on. Keep always-copied assets unchanged. Include each Design template path in the
`UX Design enabled` event.

## Feasibility constraints and resolutions

| ID | Constraint | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- |
| UX-C-01-1 | Declare `ux-design.enable` with `mkBoolOpt` default false, renders no file. | `composition/artifact-driven/default.nix:153-199`, `libs/nix/options`. | UX-P2-01 Interface in `spec-ux-design-option`. | `factory-expert` | Declare the option with `_utils.mkBoolOpt`, default it to `false`, and attach no file to the declaration. |
| UX-C-01-3 | Off must be byte-identical: do not edit always-copied assets (`AGENTS.md`, artifact README, mixture page whole-file copies); use enable-keyed variant or appended optional chapter. | Composition lines 416-463, documentation lines 16-29, and exact evaluation comparisons. | Off equality. | `factory-expert + solution-expert` | Keep all always-copied assets unchanged. Use enable-gated files and optional role chapters for UX Design output. |
| UX-C-01-4 | UX Design enabled event payload needs Design template paths if factory emits template. | Aggregate line 107 and specification line 30. | `UX Design enabled` event. | `solution-expert` | Add each generated Design template path to the event contract and aggregate payload. |

## Consequences

The aggregate canvas records the UX Design invariants and the conditional event. The composition
code must enforce the rules at the Repository blueprint boundary. Evaluation must prove the
byte-identical off output.
