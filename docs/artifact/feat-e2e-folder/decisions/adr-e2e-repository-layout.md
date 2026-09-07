# adr-e2e-repository-layout: Use one shared E2E repository

**Relates to:** spec-e2e-seed

## Context

End-to-end tests can use one repository or several repositories.
The repository boundary must be clear for the polyrepo layout.

## Options

1. Use one shared E2E repository. This option gives one location for cross-component workflow tests.
2. Use one repository for each E2E suite. This option gives each suite an independent lifecycle.
3. Do not specify a repository boundary. This option lets each project select its own layout.

## Decision

Use one shared E2E repository.
This repository contains tests for workflows that use more than one application or service.

## Consequences

The polyrepo layout has one repository at `e2e/`.
All cross-component workflow tests use the same repository lifecycle and access rules.
