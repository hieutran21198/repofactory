# task-artifact-synchronizer: Build the artifact synchronizer

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-only, req-artifact-hierarchy, req-portable-links, spec-artifact-tree, spec-sync-workflow
**Context:** context-factory

## Goal

Build the provider-neutral artifact discovery, identity, hierarchy, and merge logic.

## Steps

1. Classify every supported feature artifact path.
2. Read issue titles and decision parent links from Markdown.
3. Process new, changed, renamed, and deleted paths.
4. Add a complete-tree scan for setup and recovery.
5. Add stable issue bodies and identity markers.

## Check

Run unit checks against artifact-tree and pull-request fixtures.
