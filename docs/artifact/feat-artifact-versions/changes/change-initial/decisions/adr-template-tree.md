# adr-template-tree: Put the artifact templates under `templates/change/`

**Relates to:** spec-template-tree
**Context:** context-factory

## Context

Every unit of work on a feature is a change. The requirements, the specifications, the decisions,
and the tasks are written inside `changes/change-<name>/`. The templates of these artifacts are
under `templates/feature/` today. The folder name says where the copy goes, so the folder name
must match the new destination.

## Options

1. Move the artifact templates to `templates/change/`. `templates/feature/` keeps only the feature
   README template. Pro: the template path names the destination; the copy instruction in each
   role is one line. Pro: `git mv` keeps the history. Con: every role and the wiki page must name
   the new path.
2. Keep the artifact templates under `templates/feature/`. Pro: no file moves. Con: the path says
   "feature" but the copy goes into a change; each role needs one sentence to explain it. Con:
   `templates/change/README.md` and `templates/feature/requirements/` are in two folders for one
   destination.
3. Flatten the templates into `templates/` without a `feature/` or `change/` folder. Pro: the
   shortest paths. Con: the feature README template and the change README template are both named
   `README.md` and cannot share one folder; one of them needs a new name that breaks the
   "copy and rename nothing" rule.

## Decision

Select option 1. The path of a template names its destination. The roles and the wiki page change
in this feature in any case, so the new path costs no extra work.

## Consequences

A copy instruction reads `templates/change/requirements/` for a change and
`templates/feature/README.md` for a feature. The Nix module needs no change, because the whole
`templates` directory is one file entry. An evaluation check asserts that the old folders are
absent.
