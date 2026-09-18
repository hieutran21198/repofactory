# Change: Sidebar sort order

**Feature:** [Documentation site](../../README.md)
**From:** 8.0.0
**To:** 9.0.0
**Type:** Requirements

## Reason

The documentation site renders correctly, but the sidebar lists pages in no clear order. Readers
cannot find pages by position and cannot trust the order of versions, changes, or artifact phases.
The sidebar shows decision folders before specification folders, which contradicts the
artifact-driven phase order. Feature folders (`feat-*`) appear in alphabetical order, which does
not follow the dependency path from architecture through delivery to the documentation site.

The feature needs a deterministic sidebar sort order: index pages first, artifact phases in phase
order (requirements, specifications, decisions, tasks), versions in descending semantic version
order, `change-initial` first with the remaining changes alphabetical, other pages alphabetical
(case-insensitive by display label), and feature folders in dependency path order through an
explicit order list. Downstream projects need the same generic rules in the factory copy plus a
new typed option for their own feature order, rendered into `site.json` for the site
configuration to read. The user approved the new option.

## Artifacts

- [Requirements](requirements/README.md)
