# req-version-is-full-state: A version holds the full state

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

When the code of a change exists, phase 5 (Version) must produce
`docs/artifact/feat-<name>/versions/<version>/`. The version folder must hold the full
requirements, the full specifications, and the full decisions of the feature at that version. The
feature README must name the current version and must have a table that maps each version to its
change. A version must be produced by copy only: copy the previous version, copy the files of the
change over it, and delete the removed artifacts. A file under `versions/` must never be edited.

## Acceptance criteria

- Given a change whose code exists, when the solution expert does phase 5, then a new folder `versions/<version>/` exists with the requirements, the specifications, and the decisions of the feature at that version.
- Given a feature with a version, when a reader needs the current state, then the reader gets the full state from `versions/<current>/` only.
- Given a feature with a version, when a reader opens the feature README, then the README names the current version and has one table row for each version with a link to its change.
- Given a previous version and a change, when the solution expert produces the new version, then each file in the new version is a copy of a file in the previous version or a copy of a file in the change, and each artifact that the change removes is not in the new version.
- Given a file under `versions/`, when a correction is necessary, then the correction goes into a change and a new version, and the file under `versions/` does not change.

## Notes

Tasks are not part of a version. They exist only in a change.
