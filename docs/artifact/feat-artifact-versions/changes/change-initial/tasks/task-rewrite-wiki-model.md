# task-rewrite-wiki-model: Rewrite the wiki page of the model

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, req-change-is-unit-of-work, req-version-is-full-state, req-semver-by-type, spec-wiki-model
**Context:** context-factory

## Goal

The seeded wiki page describes a change as the unit of work, a version as the full state, and phase 5 as copy and delete.

## Steps

1. Open
   `services/factory/domain/documentation/artifact-driven/_assets/docs/wiki/documentation/artifact-driven/README.md`.
2. Replace the full text of the file with the text of section `### Full replacement text` of
   spec-wiki-model. Copy the text as it is.
3. Make sure that the file has these headings: `## Directory structure`, `## Artifact types`,
   `## Names`, `## Where to read`, `## The five phases`, `### Phase 1: Requirements`,
   `### Phase 2: Specifications`, `### Phase 3: Plan`, `### Phase 4: Implementation`,
   `### Phase 5: Version`, and `## Rules for the artifacts of a change`.
4. Make sure that the file has the texts `changes/change-initial/`, `versions/`,
   `templates/change/`, and `Correction`.
5. Make sure that the file does not have these texts of the old model:
   `update the master artifacts`, `Present only after a change to a feature whose code exists`,
   `templates/feature/requirements`, `templates/feature/specifications`,
   `templates/feature/decisions`, `templates/feature/tasks`, and `### Phase 5: Change`.
6. Do not change `services/factory/domain/documentation/artifact-driven/default.nix`. The file
   entry `docs/wiki/documentation/artifact-driven/README.md` copies the source as it is.
7. Do not edit the generated copy `docs/wiki/documentation/artifact-driven/README.md`.

## Check

- `grep -c "### Phase 5: Version" <source file>` returns `1`.
- `grep -n "update the master artifacts\|### Phase 5: Change\|templates/feature/[a-z]" <source file>`
  returns nothing.
- The check `wikiHasPhases` of task-eval-checks passes:
  `nix-instantiate --eval --strict services/factory/domain/documentation/artifact-driven/tests/eval.nix`.
- Enter the shell. `diff` of the source file and `docs/wiki/documentation/artifact-driven/README.md`
  is empty.
