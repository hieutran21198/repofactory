# adr-version-readme: No README in a version folder

**Relates to:** spec-artifact-layout
**Context:** context-factory

## Context

A version folder holds copies. Phase 5 is copy and delete only. A README in each version folder
would be a written file, not a copy. The documentation site renders `docs/artifact/`. A reader who
opens `versions/1.0.0/` on the site needs a page.

## Options

1. No README in a version folder. The documentation site generates an index page for a folder
   without README and shows the folder name, the version number, as the label. Pro: phase 5 stays
   copy and delete only. Pro: nothing to write or to keep correct. Con: the index page has no
   prose; the reader goes to the feature README for the summary.
2. One README in each version folder with the version, the change that produced it, and links to
   the three master files. Pro: a prose entry page. Con: a written file in a folder that must hold
   copies only; the rule "do not edit under `versions/`" has one exception. Con: one more file to
   check in each phase 5.

## Decision

Select option 1. The site already generates the index page (`numberPrefixParser` is off, so `1.`
is not stripped from the label). The feature README is the entry page of the feature and names
the current version.

## Consequences

The version folder has three master READMEs and no folder README. The docs-site page gets one
bullet that explains the generated index. A test can check that no `versions/*/README.md` exists.
