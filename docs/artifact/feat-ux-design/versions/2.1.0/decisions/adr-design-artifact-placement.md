# adr-design-artifact-placement: Use a separate versioned Design artifact

**Relates to:** spec-phase-placement, spec-design-artifact, spec-design-ownership
**Context:** context-factory

## Context

Design is a phase 2 output, but it is not a Specification or an ADR. Later phases and later
changes need one current Design artifact. The path must keep the change history and ownership.

## Options

1. Use `design/README.md` in each applicable change and version. Pro: Design has a clear artifact
   boundary. Pro: The version keeps the current design state. Con: The artifact-driven copy rules
   need one more optional folder.
2. Use `specifications/spec-design.md`. Pro: Existing version copy rules need no new folder. Con:
   The path makes Design a Specification and gives it solution ownership.
3. Use one `design.md` at the feature root. Pro: The current design is easy to find. Con: The file
   has no version boundary. Con: A later change overwrites design history.

## Decision

Select option 1. Use `changes/change-<name>/design/README.md` for a changed Design artifact. Copy
the current file to `versions/<version>/design/README.md` in phase 5. Keep the copy-only phase 5
rule.

Emit the Design template from the enabled artifact-driven composition. Do not put it in the
always-copied template source. Add the Design copy rule through the optional release role chapter.

## Feasibility constraints and resolutions

| ID | Constraint | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- |
| UX-C-03-2 | Optional Design template must be gated: documentation domain copies whole templates folder when on, so Design template inside would ship when off; emit conditionally from composition or gate copy. | Documentation default lines 21-24, the placement decision, and aggregate line 68. | Design template delivery. | `solution-expert + factory-expert` | Keep the template outside the always-copied source. Emit its target path only from the enabled composition branch. |
| UX-C-03-3 | `versions/design` needs no new option: phase 5 role body adds `design/` to step 3 conditionally; count stays 5. | Release role lines 30-45. | `spec-phase-placement` version copy. | `factory-expert` | Add `design/` through the enabled release role chapter. Keep the copy-only rule and five phases. |
| UX-C-07-1 | Path + five sections authored in designer `ROLE.md` + optional template; no option; gate template per UX-C-03-2. | Designer role and optional template delivery. | `spec-design-artifact`. | `factory-expert` | Put the path and five-section contract in the designer role and conditional template. Add no artifact option. |

## Consequences

The enabled composition supplies an optional `design/` template. Phase 5 copies the folder but
does no design work. A change file is a full replacement of the current Design artifact. The off
output does not contain the template.
