# spec-artifact-layout: Feature artifact layout

**Master:** [Specifications](README.md)
**Covers:** req-change-is-unit-of-work, req-version-is-full-state, req-change-holds-deltas, req-semver-by-type, req-no-status
**Context:** context-factory

## Description

This specification is the directory contract of one feature in `docs/artifact/`. Every other
specification of this feature refers to it. A feature has two kinds of folders: a change holds
the work of one unit of work, and a version holds the full state of the feature after one change.
The wiki page, the templates, the roles, the synchronizer, and the migration all follow this
contract.

## Contract

### Directory structure

```text
docs/artifact/
    README.md                       The index of the features.
    feat-<name>/
        README.md                   The feature summary. Names the current version.
        changes/                    Required. One folder for each change.
            change-initial/         Required. The first build of the feature.
                README.md           The change summary. From none, To 1.0.0.
                requirements/       Required in change-initial.
                specifications/     Required in change-initial.
                decisions/          Optional.
                tasks/              Required in change-initial.
            change-<name>/          One folder for each later change.
                README.md           The change summary. From, To, Type, Reason.
                requirements/       Present only if a requirement changes.
                specifications/     Present only if a specification changes.
                decisions/          Present only if a decision changes.
                tasks/              Present only if the change needs code.
        versions/                   Present after the first phase 5.
            <major>.<minor>.<patch>/
                requirements/       The full requirements at this version.
                specifications/     The full specifications at this version.
                decisions/          The full decisions at this version. Absent if none.
```

A feature has no root `requirements/`, `specifications/`, `decisions/`, or `tasks/` folder. A
version folder has no `tasks/` folder and no `README.md`. A `versions/` folder has no `README.md`.

### What each folder holds

| Folder | Holds | Written in |
| --- | --- | --- |
| `changes/change-<name>/README.md` | The change summary: the version before, the version after, the type, and the reason. | Phase 1 |
| `changes/change-<name>/requirements/` | The master requirement and the teardown requirements of the change. | Phase 1 |
| `changes/change-<name>/specifications/` | The master specification and the teardown specifications of the change. | Phase 2 |
| `changes/change-<name>/decisions/` | The decisions of the change. | Phase 2 |
| `changes/change-<name>/tasks/` | The implementation plan and the tasks of the change. | Phase 3 |
| `versions/<version>/` | A copy of the requirements, the specifications, and the decisions of the feature at that version. | Phase 5 |

### Names

- A change folder is `change-<name>`. `<name>` has lowercase letters, digits, and hyphens.
- The first change of a feature is `change-initial`.
- A version folder is `<major>.<minor>.<patch>`. Each part is a decimal number without a leading
  zero. The first version of a feature is `1.0.0`.
- The change README gives the version before the change in `**From:**` and the version after the
  change in `**To:**`. `change-initial` has `**From:** none` and `**To:** 1.0.0`.

### The version number by change type

The `**Type:**` line of the change README gives the next version. The version before the change
is `major.minor.patch`.

| Type | Meaning | To |
| --- | --- | --- |
| Requirements | A requirement is added, changed, or removed. | `major+1.0.0` |
| Specifications | Only a specification changes. No requirement changes. | `major.minor+1.0` |
| Decisions | Only a decision changes. No requirement changes. | `major.minor+1.0` |
| Correction | An artifact text is corrected. No requirement, no specification contract, and no decision changes. | `major.minor.patch+1` |

A `**Type:**` line can name two types, for example `Specifications, Decisions`. The first type
gives the bump. The type `Requirements` is always the first when present. The type of
`change-initial` is `Requirements`.

### The artifacts of a change

- Each file in `changes/change-<name>/requirements/`, `specifications/`, or `decisions/` is the
  full replacement text of one artifact. The file has the same filename as the artifact that it
  replaces in `versions/<from>/`. A filename that is not in `versions/<from>/` is a new artifact.
- A change holds only the artifacts that change. A change does not copy an artifact that does not
  change.
- When the list of teardown artifacts of a folder changes, the change holds the master
  `README.md` of that folder. The master lists every teardown artifact of the folder at the new
  version, not only the artifacts of the change.
- A master README in a change has the line
  `**Change:** [<change title>](../../../changes/change-<name>/README.md)` under its title. The
  long relative path resolves from the change folder and from the version folder. A teardown
  artifact keeps its `**Master:**` link to the master in the same folder.
- A change that removes an artifact lists its path under the heading `## Removed artifacts` in
  the change README. Each item is one path relative to the version folder, for example
  `specifications/spec-old-api.md`. A change that removes no artifact has no such heading.
- A correction to a change before its phase 5 is made in place in the change. It is not a second
  change.
- Tasks exist only in a change. A version has no tasks.

### The version folder

`versions/<to>/` is the result of these operations and nothing else:

1. A copy of `versions/<from>/`. For `change-initial`, the copy is empty.
2. The files of `changes/<change>/requirements/`, `specifications/`, and `decisions/` copied over
   the copy. A file with the same path replaces the file in the copy.
3. The paths under `## Removed artifacts` of the change README deleted from the copy.

Each file in `versions/<to>/` is byte-identical to a file in `versions/<from>/` or to a file in
the change. No file under `versions/` is edited. A correction to a file under `versions/` is a new
change and a new version.

The domain model in `docs/domain/` has no version. No file of `docs/domain/` is copied into
`versions/`.

### The feature README

The feature README `docs/artifact/feat-<name>/README.md` has these parts in this order:

1. The title `# Feature: <title>`.
2. The line `**Current version:** <version>`. The version is text, not a link: the site builder
   reads a path such as `versions/1.0.0/` as a file with the extension `.0`. Before the first
   phase 5 the line is `**Current version:** none`.
3. The section `## Summary`.
4. The section `## Current artifacts` with links to `versions/<version>/requirements/README.md`,
   `versions/<version>/specifications/README.md`, and `versions/<version>/decisions/` when the
   version has decisions. The section is absent before the first phase 5.
5. The section `## Versions` with one table. The first three columns are `Version`, `Change`,
   and `Type`. A README can append more columns. One row for each change, in the order of the
   changes. The `Version` cell is the `To` of the change. The `Change` cell links to
   `changes/change-<name>/README.md`. A change before its phase 5 has a row: its version has no
   folder yet.
6. The section `## Artifacts` with a link to `changes/` and a link to `versions/`.

### The change README

The change README `changes/change-<name>/README.md` has these parts in this order:

1. The title `# Change: <title>`.
2. The lines `**Feature:** [<feature title>](../../README.md)`, `**From:** <version or none>`,
   `**To:** <version>`, and `**Type:** <type>`.
3. The section `## Reason`.
4. The section `## Artifacts` with one link for each folder that the change holds.
5. The section `## Removed artifacts` only when the change removes an artifact.

### Where to read

| Need | Read |
| --- | --- |
| The current state of a feature | `versions/<current>/`, where `<current>` is the version in the feature README. |
| The reason for a change | `changes/change-<name>/README.md`. |
| The work of a change | `changes/change-<name>/tasks/`. |
| The artifacts that a change touched | `changes/change-<name>/`. Do not read a change to learn the full state. |
| The history of a feature | The `## Versions` table of the feature README. |

### No status

No file of this layout records a status or a phase-tracking field. A version number is the size
of the contract change; it is not a status.

## Errors

- A feature with a root `requirements/`, `specifications/`, `decisions/`, or `tasks/` folder does
  not follow this contract. The synchronizer stops on it (see spec-sync-classifier).
- A change README without `**From:**`, `**To:**`, or `**Type:**` does not follow this contract.
- A `**To:**` that does not match the bump of the `**Type:**` from `**From:**` is an error in the
  change README. Correct it in the change before phase 5.
- A file under `versions/` that is not byte-identical to its source in `versions/<from>/` or in
  the change is an error. Remove the version folder and produce it again by copy.
- A `versions/<to>/` folder for a change whose code does not exist is an error. Remove it.
