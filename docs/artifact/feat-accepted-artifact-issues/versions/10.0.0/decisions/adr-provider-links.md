# adr-provider-links: Keep provider links out of artifacts

**Relates to:** spec-artifact-tree
**Context:** context-factory

## Context

An issue does not exist until after the artifact merges. A provider URL in the artifact needs a
second repository change and binds the artifact to one provider.

## Options

1. Add the issue URL to artifact frontmatter. Pro: The artifact links directly to its issue. Con: CI must change accepted content.
2. Store links only in the issue and merged pull request. Pro: The artifact stays provider-neutral. Con: Reverse navigation uses Git history.

## Decision

Store provider links in the issue and one managed pull request comment. Do not change artifact
frontmatter.

## Consequences

Provider changes do not change artifact files. Readers use the merged pull request for reverse
navigation.
