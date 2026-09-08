# task-map-context-to-src: Map a bounded context to src/

**Plan:** [Implementation plan](README.md)
**Covers:** req-single-context-rule, spec-single-context-home

## Goal

The DDD assets give the home of a bounded context for both architectures.

## Steps

1. Edit the section "Where a context lives" and step 5 of the procedure in the design guide.
2. Edit the `**Component:**` line of the bounded context template.
3. Edit the phase 4 row of the phase-mapping page.
4. Edit the phase 2 steps and the first rule of the DDD chapter of the solution expert.
5. Keep each edit to one sentence for each architecture. Do not change the rule of the multiple
   repositories architecture.

## Check

Search the DDD assets for `services/`. Each hit that gives the home of a context also gives
`src/`. The existing checks of the DDD module and the composition pass.
