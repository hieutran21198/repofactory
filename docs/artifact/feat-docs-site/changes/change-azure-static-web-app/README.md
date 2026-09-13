# Change: Add Azure Static Web App publication target

**Feature:** [Documentation site](../../README.md)
**From:** 5.0.0
**To:** 6.0.0
**Type:** Requirements

## Reason

Repository teams that publish to Azure need Azure Static Web Apps as a
publication target next to GitHub Pages. One team selects exactly one target.
The selection uses a new docs-site option. The Docusaurus output stays the
source. The default target stays GitHub Pages, so current projects keep their
behavior. Both CI providers support both targets.

## Artifacts

- [Requirements](requirements/README.md)
