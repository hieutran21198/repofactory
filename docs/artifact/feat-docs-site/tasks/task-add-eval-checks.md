# task-add-eval-checks: Add the docs-site evaluation checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing, spec-eval-checks
**Context:** context-factory

## Goal

The check file `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` asserts and
exports the thirteen checks of `spec-eval-checks`.

## Steps

1. Write the stub `lib` with `mkIf`, `mkMerge`, `mkForce`, `optionalString`, and
   `optionalAttrs`, and the identity `optionUtils` with `mkBoolOpt` and `mkStrOpt`, as in
   `services/factory/composition/artifact-driven/tests/eval.nix`.
2. Write `moduleFor` and `evalModule` with the exact arguments and defaults of
   `spec-eval-checks`.
3. Write the seven configurations `on`, `off`, `single`, `noCi`, `noModel`, `emptyUrl`, and
   `badBaseUrl` with the arguments of the table, and the list `invalidSetups`.
4. Write the bindings `site`, `copyFiles`, `seedFiles`, `allFiles`, `sourced`, `fileOf`,
   `textOf`, `matches`, `assertionsPass`, `pkg`, and `lock` with the exact values of
   `spec-eval-checks`.
5. Write the thirteen checks with the conditions of the table. `configMatches` has seven
   patterns, the first is `trailingSlash: true`. `workflowMatches` has six patterns.
6. Add the thirteen names to the `assert` list and to the `inherit` list in the order of the
   table.
7. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.
8. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
9. Make one negative test. In
   `services/factory/composition/artifact-driven/docs-site/_assets/apps/documentation/docusaurus.config.js`,
   change `trailingSlash: true` to `trailingSlash: false`. Run the command of step 7 again and
   confirm that the evaluation fails on `configMatches`. Then change the value back to
   `trailingSlash: true` and run the command of step 7 again.
10. Run `git diff --check`.

## Check

Step 7 exits 0. The output has the thirteen names, each with the value `true`. Step 8 exits 0
with each existing check `true`. The negative test of step 9 fails with an assertion error on
`configMatches`, and the run after the restore exits 0. Step 10 reports no error.
