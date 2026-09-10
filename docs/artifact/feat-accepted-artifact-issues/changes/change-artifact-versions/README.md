# Change: Artifact versions

**Feature:** [Accepted artifact issues](../../README.md)
**From:** 8.0.0
**To:** 8.1.0
**Type:** Specifications

## Reason

The artifact-driven documentation model moves the artifacts of a feature into
`changes/change-<name>/` and `versions/<version>/` (see the feature
[Artifact versions](../../../feat-artifact-versions/README.md)). The synchronizer contract
`spec-artifact-tree` names the old root folders as artifact forms. The contract must name the
change folders, must ignore the version folders, and must reject the old root folders.

## Artifacts

- [Specifications](specifications/README.md)

This change has no `tasks/`. The code of this change is implemented under the feature
`feat-artifact-versions` (see its specification `spec-sync-classifier`). The version `8.1.0` of
this feature is produced when that code exists.
