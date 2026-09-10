# Specifications: Artifact versions

**Change:** [Initial](../README.md)

## Solution

One directory contract, [spec-artifact-layout](spec-artifact-layout.md), defines the layout of a
feature: `changes/change-<name>/` holds one unit of work with full replacement files, and
`versions/<version>/` holds the full state after one change, made by copy in phase 5. Every other
specification applies that contract to one component or one file group.

The component `services/factory` seeds the model: the wiki page and the templates in
`domain/documentation/artifact-driven/`, and the role bodies, the skills, the agent guidance, and
the synchronizer in `composition/artifact-driven/`. The roles change owners: the requirement expert
writes the change README of every change in phase 1; the solution expert owns phases 2, 3, and 5.
The synchronizer `sync.py` classifies only the feature README and the files inside a change,
ignores `versions/`, and stops on the old root layout. Nix evaluation checks and Python tests hold
the contracts.

The component `e2e/` moves its fixture tree into `changes/change-initial/` and adds one live
scenario for a version snapshot. The live bodies `utils/agent/role/*/ROLE.md` of this repository
read the tasks of a change. These parts have no dedicated expert; the solution expert wrote them.

The seven existing features of this repository migrate to the layout with one final version each.
The synchronizer contract of `feat-accepted-artifact-issues` is replaced by a change of that
feature, `changes/change-artifact-versions/`, so that its own version history records it.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-artifact-layout](spec-artifact-layout.md) | The directory contract of a feature: changes, versions, names, version numbers, the feature README, and the change README. | req-change-is-unit-of-work, req-version-is-full-state, req-change-holds-deltas, req-semver-by-type, req-no-status |
| [spec-wiki-model](spec-wiki-model.md) | The seeded wiki page of the model with the five phases and the six copy and delete steps of phase 5. | req-roles-follow-model, req-change-is-unit-of-work, req-version-is-full-state, req-semver-by-type |
| [spec-template-tree](spec-template-tree.md) | The artifact templates under `templates/change/` and the two rewritten README templates. | req-roles-follow-model, req-change-holds-deltas, req-no-status |
| [spec-requirement-expert-role](spec-requirement-expert-role.md) | The requirement expert body: one procedure for every change, the change README, and the DDD chapter anchor. | req-roles-follow-model, req-change-is-unit-of-work, req-semver-by-type |
| [spec-solution-expert-role](spec-solution-expert-role.md) | The solution expert body: phases 2, 3, and 5, the copy-from-version rules, and the role description. | req-roles-follow-model, req-version-is-full-state, req-change-holds-deltas |
| [spec-expert-role-skill](spec-expert-role-skill.md) | The expert-role skill and the implementation expert bodies read the tasks of a change and the current version. | req-roles-follow-model |
| [spec-guidance-pages](spec-guidance-pages.md) | The AGENTS.md sources, the DDD phase table, the ddd-review skill, and the docs-site page describe the model. | req-roles-follow-model |
| [spec-sync-classifier](spec-sync-classifier.md) | The synchronizer classifies change paths, ignores `versions/`, stops on the old layout, and its guide and tests. | req-sync-ignores-versions |
| [spec-e2e-fixtures](spec-e2e-fixtures.md) | The live check fixtures under `changes/change-initial/` and the version snapshot scenario. | req-sync-ignores-versions |
| [spec-eval-checks](spec-eval-checks.md) | The Nix evaluation checks of the roles, the guidance, the templates, and the wiki page. | req-roles-follow-model, req-sync-ignores-versions |
| [spec-migration](spec-migration.md) | The result of the migration of the seven existing features, the version numbers, and the hand edits. | req-migrate-existing-features, req-change-is-unit-of-work, req-version-is-full-state |

## Requirement coverage

| Requirement | Specifications |
| --- | --- |
| req-change-is-unit-of-work | spec-artifact-layout, spec-wiki-model, spec-requirement-expert-role, spec-migration |
| req-version-is-full-state | spec-artifact-layout, spec-wiki-model, spec-solution-expert-role, spec-migration |
| req-change-holds-deltas | spec-artifact-layout, spec-template-tree, spec-solution-expert-role |
| req-semver-by-type | spec-artifact-layout, spec-wiki-model, spec-requirement-expert-role |
| req-roles-follow-model | spec-wiki-model, spec-template-tree, spec-requirement-expert-role, spec-solution-expert-role, spec-expert-role-skill, spec-guidance-pages, spec-eval-checks |
| req-sync-ignores-versions | spec-sync-classifier, spec-e2e-fixtures, spec-eval-checks |
| req-migrate-existing-features | spec-migration |
| req-no-status | spec-artifact-layout, spec-template-tree |

## Decisions

- [adr-template-tree](../decisions/adr-template-tree.md): put the artifact templates under `templates/change/`.
- [adr-version-readme](../decisions/adr-version-readme.md): no README in a version folder; the site generates the index.
- [adr-change-readme-owner](../decisions/adr-change-readme-owner.md): the requirement expert writes every change README.
- [adr-legacy-layout-rejected](../decisions/adr-legacy-layout-rejected.md): the synchronizer stops on the old root layout.
- [adr-single-final-snapshot](../decisions/adr-single-final-snapshot.md): the migration makes one version folder per feature.
