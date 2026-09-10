# spec-template-tree: Artifact templates

**Master:** [Specifications](README.md)
**Covers:** req-roles-follow-model, req-change-holds-deltas, req-no-status
**Context:** context-factory

## Description

The factory copies the artifact templates to `docs/wiki/documentation/artifact-driven/templates/`
of a generated project. The source is
`services/factory/domain/documentation/artifact-driven/_assets/docs/wiki/documentation/artifact-driven/templates/`.
Today the templates of the requirements, the specifications, the decisions, and the tasks are
under `templates/feature/`. In the new model, these artifacts exist only in a change. This
specification moves them under `templates/change/` and rewrites the two summary templates. The
templates follow [spec-artifact-layout](spec-artifact-layout.md).

## Contract

### Template tree

After the change, the source folder has this tree:

```text
templates/
    feature/
        README.md                   The feature summary.
    change/
        README.md                   The change summary.
        requirements/
            README.md               The master requirement.
            req-name.md             One teardown requirement.
        specifications/
            README.md               The master specification.
            spec-name.md            One teardown specification.
        decisions/
            adr-name.md             One decision.
        tasks/
            README.md               The implementation plan.
            task-name.md            One task.
```

Move the four folders with `git mv` from `templates/feature/` to `templates/change/`.
`templates/feature/` keeps only `README.md`. No template has a status field or a phase-tracking
field.

### `templates/feature/README.md`

The full text of the template:

```markdown
# Feature: <name>

**Current version:** none

## Summary

<One or two sentences that say what the feature does and for whom.>

## Versions

| Version | Change | Type |
| --- | --- | --- |
| 1.0.0 | [Initial](changes/change-initial/README.md) | Requirements |

## Artifacts

- [Changes](changes/)
- [Versions](versions/) (present after the first version)
```

In phase 5, the line `**Current version:** none` becomes
`**Current version:** <version>` (text, not a link; see spec-artifact-layout), and the solution expert adds the section
`## Current artifacts` before `## Versions` with the links of spec-artifact-layout. The template has
no `## Current artifacts` section, because the section exists only after the first version.

### `templates/change/README.md`

The full text of the template:

```markdown
# Change: <name>

**Feature:** [<feature name>](../../README.md)
**From:** <version or none>
**To:** <version>
**Type:** Requirements | Specifications | Decisions | Correction

## Reason

<Why the feature must change.>

## Artifacts

- [Requirements](requirements/README.md) (present only if a requirement changes)
- [Specifications](specifications/README.md) (present only if a specification changes)
- [Decisions](decisions/) (present only if a decision changes)
- [Implementation plan](tasks/README.md) (present only if the change needs code)

## Removed artifacts

- `specifications/spec-name.md` (delete this section if the change removes no artifact)
```

### The master templates under `templates/change/`

Each master template gets the line `**Change:** [<change name>](../README.md)` under its title,
followed by one empty line. The rest of each file does not change.

`templates/change/requirements/README.md`:

```markdown
# Requirements: <feature name>

**Change:** [<change name>](../README.md)

## Business need

<Who needs the feature, what they need, and why.>

## Scope

- In scope: <item>.
- Out of scope: <item>.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-name](req-name.md) | <One sentence.> | Must | Should | Could |

## Acceptance

<The condition that shows that the full feature is complete.>
```

`templates/change/specifications/README.md`:

```markdown
# Specifications: <feature name>

**Change:** [<change name>](../README.md)

## Solution

<How the solution meets the requirements. Name the components that change.>

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-name](spec-name.md) | <One sentence.> | req-name |

## Decisions

- [adr-name](../decisions/adr-name.md) (delete this section if the feature has no decision)
```

`templates/change/tasks/README.md`:

```markdown
# Implementation plan: <feature name>

**Change:** [<change name>](../README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-name](task-name.md) | - |

## Definition of done

- The check of each task passes.
- The acceptance criteria of each requirement pass.
```

### The leaf templates

`req-name.md`, `spec-name.md`, `adr-name.md`, and `task-name.md` move with `git mv`. Their text
does not change.

### Module

`services/factory/domain/documentation/artifact-driven/default.nix` needs no change. The file
entry `docs/wiki/documentation/artifact-driven/templates` copies the whole `templates` folder
with `copyMode = "copy"`. A file that moves inside the folder needs no new entry.

### Check

A new `services/factory/domain/documentation/artifact-driven/tests/eval.nix` checks:

- Each file of the template tree above exists.
- `templates/feature/requirements`, `templates/feature/specifications`,
  `templates/feature/decisions`, and `templates/feature/tasks` do not exist.
- `templates/feature/README.md` matches `**Current version:** none`, `## Versions`, and
  `| Version | Change | Type |`.
- `templates/change/README.md` matches `**From:**`, `**To:**`, `**Type:**`, `Correction`, and
  `## Removed artifacts`.
- No template matches `**Status:**` or `Status`.

## Errors

- A template has a status field or a phase-tracking field. Remove the field. The check fails.
- `templates/feature/` has a subfolder. Move the subfolder to `templates/change/`. The check
  fails.
- The change README template has no `**From:**`, `**To:**`, or `**Type:**` line. Add the line.
  The check fails.
- The generated copy under `docs/wiki/documentation/artifact-driven/templates/` differs from the
  source. Enter the shell to render it again. Do not edit the copy.
