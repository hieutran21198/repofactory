# adr-legacy-layout-rejected: The synchronizer stops on the old layout

**Relates to:** spec-sync-classifier
**Context:** context-factory

## Context

The old layout kept the first build of a feature in root folders `feat-<name>/requirements/`,
`specifications/`, `decisions/`, and `tasks/`. The new layout has no root artifact folder. A
consumer repository can hold features in the old layout until it migrates. The synchronizer must
do one of two things with such a path.

## Options

1. Stop with an error that names the path. Pro: an incomplete migration is visible in the first
   workflow run after the merge. Pro: one classification table; the code has one form to test.
   Con: a consumer must migrate before the next artifact pull request merges.
2. Accept both layouts. A root-level path classifies as before; a change path classifies with the
   new table. Pro: no migration deadline. Con: two forms of the same artifact type; a feature can
   hold both a root `specifications/` and `versions/`, and no reader knows which one is current.
   Con: the model says that the root form does not exist; the code would contradict the model.
   Con: two tables to test and to keep for an unknown time.

## Decision

Select option 1. The synchronizer follows the model. A consumer migrates in one pull request that
moves the root folders into `changes/change-initial/` with `git mv`; the renamed items keep their
identity. The error message names each unsupported path.

## Consequences

The `unsupported` guard in `run()` stays. It checks only the current filename of an item that is
not removed, so that a rename from an old path or a removed old path does not stop the migration
pull request itself. The guide `project-issues.md` explains the migration in one section.
