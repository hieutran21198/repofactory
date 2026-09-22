# spec-design-artifact: Define the Design artifact

**Master:** [Specifications](README.md)
**Covers:** req-design-output
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

Each UX Design output must be one full replacement file at
`docs/artifact/feat-<name>/changes/change-<name>/design/README.md`. Phase 5 must copy it to
`docs/artifact/feat-<name>/versions/<version>/design/README.md`.

The artifact-driven composition must conditionally emit the template at
`docs/wiki/documentation/artifact-driven/templates/change/design/README.md`. The documentation
domain copies the full templates folder for every artifact-driven repository. Thus, the Design
template must not be in that always-copied source folder.

The designer role body and the conditional Design template must author the path and section
contract. The factory must not add a Design artifact option. The conditional release role chapter
must add `design/` to the phase 5 copy.

The file must start with this title and key line:

```markdown
# Design: <feature name>

**Change:** [<change name>](../../../changes/change-<name>/README.md)
```

The file must contain these sections in this order:

1. `## UX`
2. `## Layout`
3. `## Interaction`
4. `## Components`
5. `## Design System`

### Data model

| Section | Required content |
| --- | --- |
| UX | The user goal, the entry, the ordered flow, the outcomes, and the applicable empty and error paths. |
| Layout | Each surface, its regions, its content order, and its responsive rules. |
| Interaction | Each user action, system response, user feedback, focus rule, and applicable state. |
| Components | A Reused components table and a New components table. |
| Design System | An Existing tokens table and a Required additions table. |

The Components tables must use these fields:

| Table | Fields |
| --- | --- |
| Reused components | Component, source, use |
| New components | Component, purpose, reason reuse does not fit |

The Design System tables must use these fields:

| Table | Fields |
| --- | --- |
| Existing tokens | Token, source, use |
| Required additions | Item, type, value or rule, use, reason reuse does not fit |

The artifact must identify the accepted Requirements, each controlling Spec and ADR, and each
design source. Styling must come from the existing design system and theme. A required addition
must not create a feature-specific theme.

The artifact can contain an external tool reference. The reference must not replace required
Markdown content.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Design completed | Designer expert | Artifact master, phase 3 owners | The Design path, template path, section names, covered Requirements, and controlling artifacts. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each completed Design artifact has all five sections and records reuse before additions. |
| Upstream to downstream | None. The artifact contract stays in `context-factory`. |
| Component | `services/factory` |

## Description

The separate path keeps Design distinct from a Specification. The version copy gives the next
change one current Design artifact.

## Errors

- If one required section is absent, do not emit `Design completed`.
- If a reused component has no source, return the artifact for correction.
- If a new item has no reuse reason, return the artifact for correction.
- If an external reference replaces required Markdown content, return the artifact for correction.
