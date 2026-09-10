# spec-trello: Trello adapter

**Master:** [Specifications](README.md)
**Covers:** req-artifact-hierarchy, req-configurable-status, req-portable-links
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The Trello adapter creates one card for each artifact. It uses descriptions for metadata, lists for
status, and card links for the logical artifact hierarchy. It supports Trello Free workspaces.

## Contract

- Find the board by its configured ID.
- Optionally route implementation plans and tasks to a separate implementation board.
- Move an existing card to its configured board and preserve its identity.
- Require only the statuses used on each configured board and the withdrawn status.
- Require one unique list for each configured status.
- Find managed cards by their hidden artifact marker.
- Add exactly one managed `artifact:<kind>` label and preserve other labels.
- Put the artifact path, type, feature, source links, acceptance links, and marker in the description.
- Put the parent card URL and artifact path in each child card.
- Put each child card URL in a `Children` checklist on its parent card.
- Use the stable Trello short URL for parent and child card links.
- Move a withdrawn card to the configured list before the adapter archives it.
- Do not create, read, update, or delete Trello Custom Fields.
- Create missing managed labels on the board.

## Errors

- Stop if the board or a configured list does not exist.
- Stop if two cards contain the same artifact marker.
- Stop if two configured board IDs are equal.
- Stop if the Trello API rejects a card or checklist change.
