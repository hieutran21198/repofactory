# req-designer-scope: Design from fixed inputs and prefer reuse

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The designer expert must design the UX flow, the layout, the interaction, and the components of
the feature. It must use the accepted Requirements, the current Specs, the current ADRs, and the
existing design system, theme, and UI components as its inputs. It must reuse existing
components and tokens when reuse fits. It must define new components and variables only when
reuse does not fit.

## Acceptance criteria

- Given the Specs and ADRs phase, when the designer expert starts, then it reads the accepted Requirements, the current Specs, the current ADRs, and the existing design system, theme, and UI components.
- Given an existing component or token that fits the need, when the designer expert designs, then it reuses the existing component or token.
- Given no existing component or token that fits the need, when the designer expert designs, then it defines a new component or variable and records the addition in the Design artifact.

## Notes

Styling comes from the existing system and theme. The designer expert does not redefine styling
per feature.
