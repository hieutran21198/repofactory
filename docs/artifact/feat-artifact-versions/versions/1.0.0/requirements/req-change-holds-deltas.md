# req-change-holds-deltas: A change holds only the artifacts that change

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

A change after the first must hold only the artifacts that change. Each such file must be the full
replacement text of the artifact, with the same filename as the artifact that it replaces. A new
filename is a new artifact. A folder's master README is part of the change when its list of
teardown artifacts changes. The change README must list the removed artifacts. Before phase 5, a
correction to a change must be made in place in the change, not in a second change.

## Acceptance criteria

- Given a feature with a version and a change that changes one specification, when the solution expert writes the change, then the change holds that specification with the same filename as in the current version, and no other specification.
- Given a change that adds a teardown artifact, when the solution expert writes the change, then the change holds the new artifact and the master README of its folder with the new artifact in its list.
- Given a change that removes an artifact, when a reader opens the change README, then the README lists the removed artifact.
- Given a change with a file that has the same filename as an artifact in the current version, when the solution expert produces the version, then the file replaces the artifact in full.
- Given a change before phase 5 and an error in one of its artifacts, when the author corrects the error, then the correction is in the same change and no second change exists.

## Notes

A full replacement file is easier to copy than a difference. The copy in phase 5 depends on this
rule.
