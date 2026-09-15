# task-moex-delivery: Wire and check wiki delivery

**Plan:** [Implementation plan](README.md)
**Covers:** req-moex-nix-delivery, spec-moex-delivery
**Context:** context-factory

## Goal

Make the Nix composition copy the page and verify page delivery for all four repository variants.

## Files

- `services/factory/composition/artifact-driven/default.nix`
- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Add the specified multiple-layout page entry to the multiple-layout files set.
2. Set its source to the multiple-layout mirror.
3. Set its `copyMode` to `"copy"`.
4. Add the specified single-layout page entry to the single-layout files set.
5. Set its source to the single-layout mirror.
6. Set its `copyMode` to `"copy"`.
7. Apply each entry when DDD is true or false.
8. Extend the composition evaluation for the four layout and DDD combinations.
9. Assert that each generated files set contains the page entry.
10. Assert the specified source and `copyMode` for each page entry.
11. Assert that both mirrors exist and match the canonical page.
12. Assert that each selected wiki index contains the specified link.
13. Assert the required page sections, role rows, and phase rows.
14. Keep page delivery disabled when artifact-driven documentation is not selected.
15. Keep page delivery disabled when no supported repository layout is selected.
16. Run the artifact-driven composition evaluation.

## Check

Run
`nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
The command must return the result attribute set without an assertion error.

## Errors

- A missing page source or index source must fail the evaluation.
- A mirror that differs from the canonical page must fail the evaluation.
- A missing file entry or a different `copyMode` must fail the evaluation.
- A missing required page section or table row must fail the evaluation.
