# req-migrate-existing-features: Migrate the existing features

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

The seven existing features in `docs/artifact/` of this repository must move to the new layout.
The root artifacts of each feature must move into `changes/change-initial/`. Each existing change
README must get From, To, and Type. Each feature must get one `versions/<current>/` folder whose
master READMEs list the union of all the artifacts of the feature. The version numbers of the
existing changes must be counted in git order by Type. Only the final version folder must exist.
The intermediate version folders must not exist.

## Acceptance criteria

- Given the migration, when a reader lists the root folders of each of the seven features, then no feature has a root `requirements/`, `specifications/`, `decisions/`, or `tasks/` folder, and each feature has `changes/change-initial/`.
- Given the migration, when a reader opens an existing change README, then it states From, To, and Type.
- Given the migration, when a reader opens `versions/<current>/` of a feature, then each master README lists each teardown artifact of the feature, and the specification of the Trello provider of `feat-accepted-artifact-issues` contains the board ID contract.
- Given the migration, when a reader opens the feature READMEs, then `feat-accepted-artifact-issues` names 8.0.0, `feat-docs-site` names 3.0.0, `feat-single-repo-arch` names 1.1.0, and `feat-e2e-folder`, `feat-ddd-design`, `feat-expert-role-skill`, and `feat-ddd-review-skill` name 1.0.0.
- Given the migration, when a reader lists `versions/` of a feature, then it has one folder, the current version.

## Notes

The version numbers come from the types of the existing changes in git order. The migration does
not make a version folder for each intermediate version, because no reader needs them.
