# req-parallel-implementation: Run independent tasks in parallel

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must make ordered work batches for phase 4 from
the recorded dependencies and each `can-parallel` answer. Phase 4
must run tasks in parallel where the recorded dependencies permit
it. Tasks in different components or contexts with no dependency
must run in parallel. Tasks in the same aggregate or context must
run in sequence. A downstream task that consumes an upstream result
must run after the upstream task. Shared kernel or published
language code in libraries must come first. Phase 3 must record the
dependency and the parallel answer for each task. The answer is yes
or no. Phase 4 must keep one commit.

## Acceptance criteria

- Given phase 3 output, when phase 4 starts, then the artifact master makes ordered work batches from the recorded dependencies and each yes-or-no parallel answer.
- Given tasks in different components or contexts with no dependency, when phase 4 runs, then it runs them in parallel.
- Given tasks in the same aggregate or context, when phase 4 runs, then it runs them in sequence.
- Given a downstream task that consumes an upstream result, when phase 4 runs, then the upstream task comes first.
- Given shared kernel or published language code in libraries, when phase 4 runs, then that code comes first.
- Given a phase 3 plan, when the user reads a task, then the user can identify its dependency and its yes-or-no parallel answer.
- Given phase 4, when it ends, then one commit holds its output.

## Notes

The parallel answer of a task is `can-parallel: yes` or
`can-parallel: no`. Phase 3 records it for each task. A work batch
is one ordered group of phase 4 tasks.
