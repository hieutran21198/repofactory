# spec-trello: Trello adapter

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The Trello adapter creates one card for each artifact. It uses lists for status and card links for
the logical artifact hierarchy.

## Contract

- Find the board by its configured ID.
- Require one unique list for each configured status.
- Require text custom fields named `Artifact path`, `Artifact type`, and `Parent artifact`.
- Find managed cards by their hidden artifact marker.
- Put the parent card URL and artifact path in each child card.
- Put each child card URL in a `Children` checklist on its parent card.
- Move a withdrawn card to the configured list before the adapter archives it.

## Errors

- Stop if the board, a configured list, or a required custom field does not exist.
- Stop if two cards contain the same artifact marker.
- Stop if the Trello API rejects a card or checklist change.
