# spec-resolve-trello-board-id: Use the internal ID for labels

**Master:** [Specifications](README.md)
**Covers:** req-resolve-trello-board-id
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The Trello adapter keeps the configured board reference for board reads. During preflight, it reads
the board and saves its `id` in the board context. It uses that saved ID as `idBoard` when it creates
a missing managed label.

## Contract

For each board in use, preflight first calls `GET /boards/<configured-reference>?fields=id`. The
response must contain an `id`. The adapter stores that value in `self.boards[board]["id"]`.

When `POST /labels` creates a managed label, its `idBoard` value is the stored board ID, not the
configured board reference. Board list, label, and card reads continue to use the configured
reference.

## Errors

The adapter stops when the board response has no `id`. The existing HTTP error includes the failed
request when Trello rejects the board lookup.
