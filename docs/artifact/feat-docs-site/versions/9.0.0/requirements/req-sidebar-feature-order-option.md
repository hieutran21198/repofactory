# req-sidebar-feature-order-option: Offer a feature order option for the sidebar

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must offer a typed docs-site option for the sidebar feature order at
`factory.composition.artifact-driven.docs-site.sidebar.feature-order`. The option must be a list
of strings with a default of an empty list. The factory must render the selected value into
`site.json` so the site configuration can read it. A documented folder that appears in the list
must sort by its position in the list. A documented folder that does not appear in the list
must sort alphabetically after the listed folders.

## Acceptance criteria

- Given a project that leaves the option unset, when the factory renders `site.json`, then the feature order value is an empty list and feature folders sort alphabetically.
- Given a project that sets the option to a list of folder names, when a reader opens the sidebar, then the listed folders come first in list order.
- Given a project that sets the option to a partial list, when a reader opens the sidebar, then the unlisted folders come after the listed folders in alphabetical order.
- Given a project that sets the option to a value of the wrong type, when the factory evaluates the composition, then the evaluation stops with a type error.
- Given a project that sets the option, when the factory renders the blueprint, then `site.json` holds the selected list.

## Notes

The exact Nix spelling of the option follows the existing hyphen convention of the docs-site
options and phase 2 defines it. An empty default keeps the current alphabetical behavior for
existing projects. The user approved this new option.
