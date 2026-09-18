# req-sidebar-sort-order: Sort the sidebar in a deterministic order

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The documentation site must sort each sidebar level in a deterministic order. An index page
(`index` or `README`) must come first in its parent folder. Artifact phase folders must follow
the phase order: requirements, then specifications, then decisions, then tasks. Version folders
must follow descending semantic version order with the current version first. In a changes
folder, `change-initial` must come first and the remaining changes must follow alphabetical
order. All other pages must follow alphabetical order, case-insensitive, by display label.
Feature folders (`feat-*`) must follow the dependency path order given by an explicit feature
order list: single-repo-arch, e2e/provider-contracts, ddd-design, artifact-versions,
artifact-master, accepted-artifact-issues, docs-site, skills.

## Acceptance criteria

- Given a folder with an index page and other pages, when a reader opens the sidebar level of that folder, then the index page is the first entry.
- Given the artifact folders of one feature, when a reader opens the sidebar, then requirements come before specifications, specifications before decisions, and decisions before tasks.
- Given the versions folder of one feature, when a reader opens the sidebar, then the versions appear in descending semantic version order with the current version first.
- Given the changes folder of one feature, when a reader opens the sidebar, then `change-initial` is the first entry and the remaining changes follow alphabetical order.
- Given sibling pages outside the rules above, when a reader opens the sidebar, then the pages appear in case-insensitive alphabetical order by display label.
- Given the feature folders of the documentation tree, when a reader opens the sidebar, then the folders follow the dependency path order single-repo-arch, e2e/provider-contracts, ddd-design, artifact-versions, artifact-master, accepted-artifact-issues, docs-site, skills.
- Given the current site where decisions appear before specifications, when the new order applies, then specifications appear before decisions.

## Notes

The explicit feature order list lives in the site configuration and phase 2 defines its exact
form. The list order above is the approved dependency path for this repository. The generic
rules also apply to the factory copy that downstream projects receive.
