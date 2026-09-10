# adr-single-final-snapshot: One version folder per migrated feature

**Relates to:** spec-migration
**Context:** context-factory

## Context

The seven existing features have between zero and twelve changes. Each change gets a version
number from its type in git order. The migration must decide how many version folders to produce
and which number the first folder gets.

## Options

1. One folder for the final version of each feature, with honest numbers: each change gets the
   number from its type, and the final folder holds the union of the root artifacts and every
   change. Pro: the number of folders equals the number of readers' needs: one. Pro: the version
   table of the feature README records every intermediate number without a folder. Con: an
   intermediate version has no folder; a reader who needs it reads the change.
2. One folder for each historical version, rebuilt from git. Pro: complete history in folders.
   Con: twelve folders for one feature, each a hand-made union that nobody reads. Con: the root
   artifacts were edited after some changes; a historical union is not reproducible from the
   change folders alone.
3. A git-baseline `1.0.0` from the first commit of each feature, plus the final folder. Pro: the
   first version is reproducible from git. Con: two folders, and the first one differs from
   `changes/change-initial/`, which holds the current root content, not the first commit. Con: no
   reader needs the first version.

## Decision

Select option 1. Phase 5 produces one folder for one change. The migration is one step that
covers all past changes, so it produces one folder. The version numbers stay honest: the feature
README lists every version with its change and its type.

## Consequences

The feature README of a migrated feature has one paragraph that says that only the current
version has a folder. The next change of each feature produces the next folder by the normal
phase 5. `feat-accepted-artifact-issues` gets `8.1.0` from `change-artifact-versions` right after
the migration.
