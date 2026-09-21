# Design: <feature name>

**Change:** [<change name>](../../../changes/change-<name>/README.md)

## UX

- User goal: <the goal of the user.>
- Entry: <where the user starts.>
- Flow: <the ordered steps.>
- Outcomes: <the result of each step.>
- Empty and error paths: <the applicable empty and error paths.>

## Layout

| Surface | Regions | Content order | Responsive rules |
| --- | --- | --- | --- |
| <surface> | <regions> | <content order> | <responsive rules> |

## Interaction

| User action | System response | User feedback | Focus rule | State |
| --- | --- | --- | --- | --- |
| <user action> | <system response> | <user feedback> | <focus rule> | <state> |

## Components

### Reused components

| Component | source | use |
| --- | --- | --- |
| <component> | <source> | <use> |

### New components

| Component | purpose | reason reuse does not fit |
| --- | --- | --- |
| <component> | <purpose> | <reason reuse does not fit> |

## Design System

### Existing tokens

| Token | source | use |
| --- | --- | --- |
| <token> | <source> | <use> |

### Required additions

| Item | type | value or rule | use | reason reuse does not fit |
| --- | --- | --- | --- | --- |
| <item> | <type> | <value or rule> | <use> | <reason reuse does not fit> |

## Ownership

The Design artifact shows how the specified behavior looks and responds to a user. It does not own
business behavior, domain rules, permissions, or constraints. Requirements, Specs, and ADRs keep
ownership of those items. When the Design artifact conflicts with a Requirement, a Spec, or an ADR,
change the Design artifact. Styling comes from the existing design system and theme.

## References

- Accepted Requirements: <paths>.
- Controlling Specs: <paths>.
- Controlling ADRs: <paths>.
- Design sources: <paths>.

An external design tool reference can be added. It does not replace the required Markdown
content.
