# Requirements: Artifact versions

**Change:** [Initial](../../../changes/change-initial/README.md)

## Business need

The AI agents (the requirement expert, the solution expert, and the implementation experts) and
the people who work with the feature artifacts of a project need the current state of a feature
in one place. The maintainers of the artifact-driven documentation model need one layout that
keeps each change and shows the full state of the feature after each change.

Today a feature has root `requirements/`, `specifications/`, `decisions/`, and `tasks/` folders,
and one `changes/change-<name>/` folder for each later change. The wiki tells the author to update
the root artifacts after a change, but nothing enforces it, and it is not done. Example: the
feature `feat-accepted-artifact-issues` has 12 changes, and its README lists 7. Its root
specification of the Trello provider does not contain the board ID contract. That contract exists
only in one change folder. An agent that needs the current state of a feature must read the root folders
and each change folder and merge them. That costs context and produces mistakes.

## Scope

- In scope: A change as the unit of work on a feature, from the first build of the feature.
- In scope: A version folder that holds the full requirements, specifications, and decisions of
  the feature at one version.
- In scope: A version number in the form major.minor.patch, given by the type of the change.
- In scope: The same model in the wiki page, the templates, the role bodies, the skills, and the
  agent guidance that the factory seeds.
- In scope: The accepted-artifact synchronizer follows the new layout and ignores version folders.
- In scope: The migration of the seven existing features of this repository to the new layout.
- Out of scope: Project issues, cards, or notifications for files under `versions/`.
- Out of scope: A README page for each version.
- Out of scope: A tool that generates a version. The solution expert makes the copy by hand or
  with the shell.
- Out of scope: A version for the domain model in `docs/domain/`.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Requirement expert, solution expert, implementation expert, repository maintainer | Change opened, Version produced, Legacy layout rejected |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-change-is-unit-of-work](req-change-is-unit-of-work.md) | Each unit of work on a feature, from the first build, must be a change in `changes/change-<name>/`. | Must |
| [req-version-is-full-state](req-version-is-full-state.md) | Each version folder must hold the full state of the feature, and the feature README must name the current version. | Must |
| [req-change-holds-deltas](req-change-holds-deltas.md) | A change after the first must hold only the artifacts that change, as full replacement files. | Must |
| [req-semver-by-type](req-semver-by-type.md) | The type of a change must give the version number in the form major.minor.patch. | Must |
| [req-roles-follow-model](req-roles-follow-model.md) | Each role and each seeded guidance file must describe the same model and the same phase owners. | Must |
| [req-sync-ignores-versions](req-sync-ignores-versions.md) | The synchronizer must create issues for changes only, ignore `versions/`, and stop on the old layout. | Must |
| [req-migrate-existing-features](req-migrate-existing-features.md) | The seven existing features of this repository must move to the new layout with honest version numbers. | Must |
| [req-no-status](req-no-status.md) | No artifact of the new layout must record a status or a phase-tracking field. | Must |

## Acceptance

Each feature in `docs/artifact/` has a `changes/` folder with one folder for each change, a
`versions/` folder with one folder for the current version, and a README that names the current
version and maps each version to its change. A reader gets the current state of a feature from
`versions/<current>/` only. The wiki, the templates, the roles, the skills, and the agent guidance
describe this model. The synchronizer creates issues for the changes and creates nothing for the
version folders. It stops with an error on a feature that keeps the old root folders.
