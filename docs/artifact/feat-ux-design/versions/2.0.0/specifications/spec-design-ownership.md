# spec-design-ownership: Keep the Design ownership boundary

**Master:** [Specifications](README.md)
**Covers:** req-ownership-boundary
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The Design artifact must show how specified behavior looks and responds to a user. It must not
define or change these items:

- Business behavior.
- Domain rules.
- Permissions.
- Constraints.

Requirements own required business outcomes. Specs own testable solution contracts. ADRs own
selected options and their reasons. The Design artifact must reference these items. It must not
replace them.

If Design conflicts with a Requirement, Spec, or ADR, the designer expert must change Design. If
Design finds an absent rule, the designer expert must report the gap to the artifact master. It
must not add the rule to Design as an authority.

The factory must put this ownership text in the conditional designer role body and the conditional
Design template. It must not add an ownership option. It must not edit an always-copied artifact
model page.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Design conflict found | Designer expert | Artifact master | The Design item, the controlling artifact, and the conflict. |
| Design corrected | Designer expert | Artifact master | The changed Design item and the controlling artifact. |

### Data model

| Design content | Permitted | Authority |
| --- | --- | --- |
| A representation of specified behavior | yes | The referenced Requirement or Spec |
| A layout or interaction choice within constraints | yes | The Design artifact |
| A business outcome or domain rule | no | Requirements or Specs |
| A permission | no | Requirements or Specs |
| A selected architecture option | no | ADRs |
| A new constraint | no | Specs or ADRs |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Design never overrides a Requirement, Spec, or ADR. |
| Upstream to downstream | None. Artifact ownership stays in `context-factory`. |
| Component | `services/factory` |

## Description

This contract separates user experience choices from business and solution authority. It also
keeps tool output outside the authority boundary.

## Errors

- If Design defines a business rule, permission, or constraint, return the item for correction.
- If Design conflicts with a controlling artifact, do not complete phase 2.
- If a controlling artifact has a gap, route the gap to its content owner through the artifact master.
