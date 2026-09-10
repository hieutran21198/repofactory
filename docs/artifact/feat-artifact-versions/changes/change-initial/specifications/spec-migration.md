# spec-migration: Migration of the existing features

**Master:** [Specifications](README.md)
**Covers:** req-migrate-existing-features, req-change-is-unit-of-work, req-version-is-full-state
**Context:** context-factory

## Description

The seven existing features in `docs/artifact/` of this repository move to the layout of
[spec-artifact-layout](spec-artifact-layout.md). Each feature gets `changes/change-initial/`, a
change README with `From`, `To`, and `Type` in each change, and one version folder that holds the
full state. This specification describes the result. It does not prescribe a tool. A shell script
or a manual copy can produce the result. The judgement edits are listed; they are made by hand in
the version folder only, before the version is committed. After that, no file under `versions/`
is edited.

## Contract

### Version numbers

The version of each change comes from its `**Type:**` in git order (the first commit that touched
the change folder). A change without a `**Type:**` line gets the type from its folders:
`requirements/` present → Requirements; else Specifications, and `Decisions` appended when
`decisions/` is present.

| Feature | Change (git order) | Type | Version |
| --- | --- | --- | --- |
| feat-accepted-artifact-issues | change-initial | Requirements | 1.0.0 |
| | change-composition-owned-policy | Specifications, Decisions | 1.1.0 |
| | change-live-provider-e2e | Specifications, Decisions (inferred) | 1.2.0 |
| | change-provider-credential-guide | Specifications, Decisions | 1.3.0 |
| | change-selective-provider-setup | Requirements (inferred) | 2.0.0 |
| | change-pull-request-comment-permission | Specifications (inferred) | 2.1.0 |
| | change-trello-free-workspaces | Requirements | 3.0.0 |
| | change-run-all-provider-checks | Specifications | 3.1.0 |
| | change-artifact-type-labels | Requirements | 4.0.0 |
| | change-split-trello-boards | Requirements | 5.0.0 |
| | change-accepted-artifact-notifications | Requirements | 6.0.0 |
| | change-multi-provider-accepted-artifact-notifications | Requirements | 7.0.0 |
| | change-trello-board-id | Requirements | 8.0.0 |
| feat-docs-site | change-initial | Requirements | 1.0.0 |
| | change-deployment-notifications | Requirements | 2.0.0 |
| | change-multi-provider-deployment-notifications | Requirements | 3.0.0 |
| feat-single-repo-arch | change-initial | Requirements | 1.0.0 |
| | change-ddd-per-arch | Specifications | 1.1.0 |
| feat-ddd-design | change-initial | Requirements | 1.0.0 |
| feat-ddd-review-skill | change-initial | Requirements | 1.0.0 |
| feat-e2e-folder | change-initial | Requirements | 1.0.0 |
| feat-expert-role-skill | change-initial | Requirements | 1.0.0 |

The current version after the migration is 8.0.0, 3.0.0, 1.1.0, 1.0.0, 1.0.0, 1.0.0, and 1.0.0
in the order of the table. Only the current version has a folder in `versions/`. The
intermediate versions have no folder (see
[adr-single-final-snapshot](../decisions/adr-single-final-snapshot.md)).

### Result per feature

For each feature `docs/artifact/feat-<name>/`:

1. `changes/change-initial/` holds the former root `requirements/`, `specifications/`,
   `decisions/` (when present), and `tasks/`, moved with `git mv`. Their content is the content
   at the commit before the migration. No root `requirements/`, `specifications/`, `decisions/`,
   or `tasks/` folder remains.
2. `changes/change-initial/README.md` exists with `**Feature:**`, `**From:** none`,
   `**To:** 1.0.0`, `**Type:** Requirements`, a `## Reason` section with the text of the
   `## Business need` section of the master requirement, and an `## Artifacts` list with one link
   for each folder of the change.
3. Each existing change README has `**From:**` and `**To:**` under `**Feature:**`. The three
   change READMEs without `**Type:**` (`change-live-provider-e2e`,
   `change-pull-request-comment-permission`, `change-selective-provider-setup`) get the inferred
   `**Type:**` line. The other lines of these READMEs are unchanged.
4. `versions/<current>/` holds `requirements/`, `specifications/`, and `decisions/` (when the
   feature has a decision). The content is the union of the former root artifacts and the
   teardown artifacts of every change in git order: each `changes/change-*/requirements/req-*.md`,
   `specifications/spec-*.md`, and `decisions/adr-*.md` is copied into the folder with the same
   name. No two files have the same name (verified: no collision exists). A change master README
   and a task are not copied.
5. The links in `versions/<current>/` and in `changes/change-initial/` resolve:
   - `../changes/change-<c>/specifications/<file>` becomes `<file>` (feat-single-repo-arch,
     `spec-single-composition.md` and `spec-single-context-home.md`).
   - `../changes/change-<c>/decisions/<file>` becomes `../decisions/<file>` (the specification
     masters of feat-accepted-artifact-issues and feat-docs-site).
   - `../../../domain/` becomes `../../../../../domain/` in the master requirement of
     feat-docs-site, in both copies.
6. The feature README follows the shape of spec-artifact-layout: `**Current version:**` links to
   `versions/<current>/`; `## Current artifacts` links into the version folder; the
   `## Versions` table has the columns `Version`, `Change`, `Type`, and `Commits`, one row for
   each change of the table above, in order; the `Commits` cell gives the first and the last
   commit of the change folder, short form. A feature with more than one change has one
   paragraph that says that only the current version has a folder. The `## Summary` text is
   unchanged.
7. `docs/artifact/README.md` has the columns `Feature`, `Version`, and `Summary`, and one
   sentence after the table: read `versions/<current>/` of a feature for its state and
   `changes/` for its history. `feat-artifact-versions` has the version `none` until its own
   phase 5.

### Hand edits in the version folder

These edits are made in `versions/<current>/` only, before the migration commit. A change folder
is not edited.

| Feature | File | Edit |
| --- | --- | --- |
| feat-accepted-artifact-issues | `8.0.0/requirements/README.md` | The teardown table lists the 11 requirements: the 4 former root requirements and the 7 requirements of the changes. The `## Business need`, `## Scope`, `## Domain`, and `## Acceptance` sections reflect the whole feature. |
| feat-accepted-artifact-issues | `8.0.0/specifications/README.md` | The teardown table lists the 17 specifications and the `## Decisions` list has the 8 decisions, with links inside the version folder. Each specification names the requirement that it covers. |
| feat-accepted-artifact-issues | `8.0.0/specifications/spec-trello.md` | The contract item "Find the board by its configured ID." becomes `Resolve each configured board reference to its internal board ID before label creation (see spec-resolve-trello-board-id).` with a link to `spec-resolve-trello-board-id.md` in the same folder. No other line changes. |
| feat-accepted-artifact-issues | `8.0.0/specifications/spec-provider-credential-guide.md` | `**Covers:** req-provider-adapters` becomes `**Covers:** req-configurable-status`. `req-provider-adapters` does not exist. |
| feat-accepted-artifact-issues | `8.0.0/specifications/spec-accepted-artifact-notification.md`, `8.0.0/requirements/req-accepted-artifact-notification.md` | One paragraph under the header lines that starts with `Superseded by` and links to the multi-provider specification or requirement of `change-multi-provider-accepted-artifact-notifications` in the same folder. The rest of the text is unchanged. |
| feat-docs-site | `3.0.0/requirements/README.md` | The teardown table lists the 5 requirements. |
| feat-docs-site | `3.0.0/specifications/README.md` | The teardown table lists the 7 specifications; the `## Decisions` list has the 5 decisions. |
| feat-docs-site | `3.0.0/specifications/spec-deployment-notification.md`, `3.0.0/requirements/req-deployment-notification.md` | One "Superseded by" paragraph that names the multi-provider artifact of `change-multi-provider-deployment-notifications`. |
| feat-single-repo-arch | `1.1.0/specifications/README.md` | The teardown table lists the 6 specifications; the `## Decisions` list has the 3 decisions. |

### Cross-feature change

`docs/artifact/feat-accepted-artifact-issues/changes/change-artifact-versions/` exists with a
change README (`**From:** 8.0.0`, `**To:** 8.1.0`, `**Type:** Specifications`), a change master
specification, and the full replacement `spec-artifact-tree.md`. It has no `tasks/`: the code is
implemented under `feat-artifact-versions`. Its phase 5 produces `versions/8.1.0/`. This folder is
written before the migration and is not moved by it.

### Checks

- `grep -rn '\.\./changes/' docs/artifact/*/versions docs/artifact/*/changes/change-initial`
  prints nothing.
- `find docs/artifact/feat-* -maxdepth 1 -type d -name 'requirements' -o -name 'specifications' -o -name 'decisions' -o -name 'tasks'`
  under `-maxdepth 1` prints nothing.
- Each feature has exactly one folder under `versions/`.
- `markdownlint docs/artifact` passes.
- Each relative link in `docs/artifact/**/*.md` resolves to a file or a folder.
- `versions/8.0.0/specifications/README.md` of feat-accepted-artifact-issues links 17
  specifications, and each link resolves inside the folder.

## Errors

- A filename collision between a root artifact and a change artifact stops the copy. The name of
  the file is reported. (None exists at the time of writing.)
- A relative link that does not resolve after the move is an error. Correct the link in the
  version folder or in `change-initial`, then run the checks again.
- A feature that keeps a root-level artifact folder is an error. The synchronizer of a consumer
  repository stops on it (see [spec-sync-classifier](spec-sync-classifier.md)).
