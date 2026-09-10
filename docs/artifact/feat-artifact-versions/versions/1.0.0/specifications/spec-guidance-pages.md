# spec-guidance-pages: Seeded guidance pages

**Master:** [Specifications](README.md)
**Covers:** req-roles-follow-model
**Context:** context-factory

## Description

The composition `artifact-driven` seeds guidance pages into a generated project: the `AGENTS.md`
file, the DDD phase page, the `ddd-review` skill, and the docs-site page. Each page names the
folders of a feature or the owner of a phase. This specification gives the replacement text of
each changed paragraph, row, or line, so that each page describes the same model as
[spec-wiki-model](spec-wiki-model.md) and [spec-artifact-layout](spec-artifact-layout.md). A line
that this specification does not name does not change.

All paths below are under `services/factory/composition/artifact-driven/`. The generated copies
under `AGENTS.md`, `docs/wiki/`, and `.claude/skills/` are not sources.

## Contract

### `AGENTS.md`, four sources

Files:

- `_assets/multiple/AGENTS.md`
- `_assets/single/AGENTS.md`
- `_assets/multiple/ddd/AGENTS.md`
- `_assets/single/ddd/AGENTS.md`

In each file, replace this paragraph:

```markdown
Keep the requirements, the specifications, the decisions, and the tasks of each feature in
`docs/artifact/`. Do the five phases in order. Commit at the end of each phase.
```

with this paragraph:

```markdown
Keep the artifacts of each feature in `docs/artifact/feat-<name>/`. Each unit of work is a change
in `changes/change-<name>/`. Each version in `versions/<version>/` holds the full state of the
feature. Read the current version for the state of a feature. Do the five phases in order. Commit
at the end of each phase.
```

The other paragraphs of each file do not change: the title, the list of pages to read, the
paragraph about the component directories, and, in the `ddd/` variants, the paragraph about
`docs/domain/`.

### DDD phase page, two sources

Files:

- `_assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md`
- `_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md`

The two files differ only in the row `4 Implementation`: `services/<name>/` in the multiple
variant and `src/<name>/` in the single variant. That row does not change.

The second paragraph of the intro becomes:

```markdown
The domain model in `docs/domain/` is shared by all features. A feature reads it, and the phase
that owns a domain artifact updates it. A change updates the domain artifacts in place, in the
phase that owns them. A change to the context map is a decision.
```

In the table `## The phases`, the output cell of row `1 Requirements` becomes:

```markdown
`docs/domain/README.md`, `glossary.md`, `context-<name>/README.md` without the messages and the component. The section `## Domain` in `changes/change-<name>/requirements/README.md`.
```

The output cell of row `2 Specifications` becomes:

```markdown
`context-<name>/agg-<name>.md`, `context-map.md`, `changes/change-<name>/decisions/adr-<name>.md`.
```

The output cell of row `3 Plan` becomes:

```markdown
`changes/change-<name>/tasks/` with `**Context:**` on each task.
```

Row 5 becomes exactly:

```markdown
| 5 Version | Solution expert | No DDD step. The version copies the feature artifacts only. | `versions/<version>/` |
```

The section `## How a feature artifact points to a domain artifact` does not change.

### `ddd-review` skill

File: `_assets/agent/skill/ddd-review/SKILL.md`.

The frontmatter does not change. In `## Read first`, the last item becomes:

```markdown
- The feature artifacts in `docs/artifact/` that are in scope: the change under review and
  `versions/<current>/` of its feature.
```

In `## Rules`, the line `- The solution expert owns phases 2 and 3.` becomes:

```markdown
- The solution expert owns phases 2, 3, and 5.
```

Every other line does not change. The check in `tests/eval.nix` matches these texts in the file,
and they stay: `## When to use`, `## Read first`, `## Procedure`, `## Checks`, `## Report`,
`## Rules`, `services/` before `src/`, `requirement expert` with `phase 1`, and `Do not change`.
The pattern `solution expert.*phases 2 and 3` of the check becomes
`solution expert.*phases 2, 3, and 5`.

### Docs-site page

File: `docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md`.

Add one item at the end of the list in `## Write pages that render`:

```markdown
- A version folder `versions/<version>/` has no README. The site generates an index page for it
  and shows the version number as the label.
```

The docs-site configuration does not change. `numberPrefixParser: false` already keeps the
version number as the label.

### Module

`composition/artifact-driven/default.nix` and `composition/artifact-driven/docs-site/default.nix`
need no change for these pages. Each page is one file entry that copies its source.

## Errors

- A seeded file tells the author to update root artifacts after a change. Remove the sentence.
  The check fails.
- A seeded file names `feat-<name>/tasks/`, `feat-<name>/requirements/`,
  `feat-<name>/specifications/`, or `feat-<name>/decisions/` as a root folder. Change the path to
  `changes/change-<name>/`. The check fails.
- The `ddd-review` skill names phases 2 and 3 as the phases of the solution expert. Add phase 5.
  The check fails.
- The DDD phase page has a row `5 Change`. Replace the row with the row `5 Version`. The check
  fails.
- A generated copy differs from its source. Enter the shell to render it again. Do not edit the
  copy.
