# adr-generated-credential-guide: Generate one provider credential guide

**Relates to:** spec-provider-credential-guide
**Context:** context-factory

## Context

Credential setup belongs to the generated integration. Users need the procedure in repositories
that contain the workflow. GitHub Projects and Trello also share security and GitHub CLI steps.

## Options

1. Put the full procedure only in this factory repository. Pro: one source is easy to maintain.
   Con: generated repositories do not contain the procedure.
2. Add all credential steps to the main project-issues page. Pro: users open one page. Con: the
   integration overview becomes difficult to scan.
3. Generate a separate credential page and link to it. Pro: generated repositories contain a
   focused procedure. Con: the composition emits one more file.

## Decision

Use option 3. Generate one page that covers both providers. Use silent local shell prompts and
standard input for secret creation. Let the user select the Trello token expiration.

## Consequences

The main setup page stays short. Users can prepare either provider without finding documentation
in the factory source. The page must stay consistent with default secret names and workflow use.
