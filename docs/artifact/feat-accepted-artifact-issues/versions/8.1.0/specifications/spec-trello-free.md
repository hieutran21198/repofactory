# spec-trello-free: Use Trello card descriptions

**Master:** [Specifications](README.md)
**Covers:** req-support-trello-free
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The Trello adapter uses the card description as the canonical metadata store. This contract works
with Trello Free workspaces.

## Card contract

Each managed card description contains this information:

- The artifact path and a link to the current version.
- The artifact type.
- The feature name.
- The accepted commit and a link to that version.
- The pull request link when it exists.
- The parent artifact path and parent card link when a parent exists.
- The hidden artifact marker with the repository and artifact path.

The hidden marker identifies a managed card. A rename keeps the card ID and changes the marker,
path, title, and links.

The configured list represents the card status. A `Children` checklist on the parent card contains
the child card link.

## API contract

Preflight reads the board lists and cards. Upsert creates or updates standard cards. Hierarchy
updates use standard checklists and checklist items.

The adapter does not call a Custom Fields endpoint. It does not create, read, update, or delete a
Custom Field. Existing Custom Fields on paid boards stay unchanged.

## Setup contract

The live-provider setup creates or reuses the Trello board and its status lists. It does not create
or check Custom Fields. A setup rerun can complete with a board from a failed older setup.

## Check contract

Adapter tests record every Trello API request. They verify that preflight and upsert make no Custom
Fields request. They also verify the description metadata and stable marker.

The live Trello inspector uses the hidden marker to select cards. It verifies descriptions, card
IDs, names, list status, rename behavior, links, and parent checklists.

## Errors

- Stop if the board does not have exactly one open list for each configured status.
- Stop if two cards contain the same artifact marker for the configured repository.
- Stop if the Trello API rejects a card or checklist change.
