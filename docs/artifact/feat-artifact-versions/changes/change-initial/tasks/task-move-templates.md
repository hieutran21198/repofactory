# task-move-templates: Move the artifact templates under `templates/change/`

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, req-change-holds-deltas, req-no-status, spec-template-tree
**Context:** context-factory

## Goal

The template tree of `services/factory/domain/documentation/artifact-driven/` has the shape of spec-template-tree.

## Steps

All paths are under
`services/factory/domain/documentation/artifact-driven/_assets/docs/wiki/documentation/artifact-driven/templates/`.

1. Run `git mv feature/requirements change/requirements`.
2. Run `git mv feature/specifications change/specifications`.
3. Run `git mv feature/decisions change/decisions`.
4. Run `git mv feature/tasks change/tasks`.
5. Replace the full text of `feature/README.md` with the text of section
   `### templates/feature/README.md` of spec-template-tree. The file has the line
   `**Current version:** none`, the section `## Versions`, and the table header
   `| Version | Change | Type |`. The file has no `## Current artifacts` section.
6. Replace the full text of `change/README.md` with the text of section
   `### templates/change/README.md` of spec-template-tree. The file has the lines `**From:**`,
   `**To:**`, `**Type:** Requirements | Specifications | Decisions | Correction`, and the section
   `## Removed artifacts`.
7. In `change/requirements/README.md`, add the line `**Change:** [<change name>](../../../changes/change-<name>/README.md)`
   under the title, followed by one empty line. Do not change the rest of the file.
8. Do step 7 in `change/specifications/README.md`.
9. Do step 7 in `change/tasks/README.md`.
10. Do not change `change/requirements/req-name.md`, `change/specifications/spec-name.md`,
    `change/decisions/adr-name.md`, or `change/tasks/task-name.md`.
11. Do not change `services/factory/domain/documentation/artifact-driven/default.nix`. The file
    entry `docs/wiki/documentation/artifact-driven/templates` copies the whole folder.

## Check

- `git status` shows the four folders as renames. `feature/` holds only `README.md`.
- `grep -rn "Status" templates/` in the source folder returns nothing.
- The checks `templateTree`, `legacyTemplatesAbsent`, `changeTemplateHasHeader`,
  `featureTemplateHasVersion`, and `noStatusInTemplates` of task-eval-checks pass:
  `nix-instantiate --eval --strict services/factory/domain/documentation/artifact-driven/tests/eval.nix`.
- Enter the shell. The copy under `docs/wiki/documentation/artifact-driven/templates/` is equal
  to the source. Do not edit the copy.
