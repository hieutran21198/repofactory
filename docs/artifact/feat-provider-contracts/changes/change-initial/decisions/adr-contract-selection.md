# adr-contract-selection: Central rule versus downstream selection

**Context:** context-factory
**Relates to:** spec-contract-layout, spec-gate-interface

## Context

The requirements allow four contract languages and three gates. The project must decide who selects the language for each wire surface and who selects the gate tools. The surfaces differ across provider teams.

## Options

1. Central selection. The factory team fixes one language for each wire surface and one tool for each gate. Pro: uniform files and uniform gate results. Con: the central team becomes a bottleneck, and some surfaces get a poor language fit.
2. Downstream selection within a conformance interface. The factory defines the allowed languages, the selection rule, and the gate interfaces with pass and fail criteria. Each downstream team selects the language and the tools for its surface. Pro: each surface gets the correct language, and each team keeps its tools. Con: the factory must review conformance, and gate output differs across teams.

## Decision

We select option 2, downstream selection within a conformance interface. The user defers language and tool choice to downstream consumer and provider teams. The specifications define extension points, conformance criteria, and selection rules without locking tools.

## Consequences

- Each team selects a language from the allowed set and records the reason.
- Each team selects gate tools that satisfy the gate interfaces.
- The factory checks conformance, not tool identity.
- A future change can narrow the allowed set without changing the interfaces.
