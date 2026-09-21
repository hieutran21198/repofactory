# req-enable-flag: Offer UX Design as an option that stays off unless selected

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must offer the option `artifact-driven.ux-design.enable` for UX Design. The default
value must be `false`. When the option is off, the artifact-driven workflow must stay unchanged.

## Acceptance criteria

- Given a new repository, when the maintainer does not set the option, then UX Design stays off.
- Given the option set to `false`, when the team runs a change, then the phases, the roles, and the artifacts stay the same as without this feature.
- Given the option set to `true`, when the team runs a change, then a designer expert joins the Specs and ADRs phase.

## Notes

The option name is `artifact-driven.ux-design.enable`. The default is `false`. No other phase
reads this option.
