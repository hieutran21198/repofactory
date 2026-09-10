# adr-single-layout: One layout for one component

**Relates to:** spec-single-page

## Context

The single repository architecture holds one component. The layout must tell an agent where the
code, the tests, the deployment configuration, and the knowledge go. The layout must work for
every language, and it must have a clear path to the multiple repositories architecture.

## Options

1. `src/`, `tests/`, `deployment/`, and `docs/` at the root. Pro: one rule for every language,
   and the same `docs/` and `deployment/` names as the multiple repositories architecture. Con:
   some languages put the code at the root by convention.
2. The root layout of the language, no rule. Pro: follows each language convention. Con: an
   agent cannot tell where the code or the tests go before it knows the language.
3. The `apps/`, `services/`, `libs/` tree of the multiple repositories architecture with one
   entry. Pro: no second layout to learn. Con: one more level for one component, and the
   architecture page of `multiple` describes many components.

## Decision

Option 1. One layout for every language. `tests/` holds the tests that start the complete
component; a unit test stays next to the code. The name `e2e/` is not used, because in the
multiple repositories architecture it names the shared test repository.

## Consequences

An agent finds the code in `src/` in every single repository project. When the project needs a
second component, the repository becomes one component directory of the multiple repositories
architecture, and `src/`, `tests/`, and `deployment/` move with it.
