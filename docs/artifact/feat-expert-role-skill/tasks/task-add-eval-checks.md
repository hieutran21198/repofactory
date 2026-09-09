# task-add-eval-checks: Add the skill checks to the composition evaluation

**Plan:** [Implementation plan](README.md)
**Covers:** req-skill-shipped-with-model, req-self-contained-guidance, req-solution-expert-hand-off, spec-skill-location, spec-eval-checks
**Context:** context-factory

## Goal

The check file `services/factory/composition/artifact-driven/tests/eval.nix` asserts and
exports the six checks of `spec-eval-checks`.

## Steps

1. Add the configuration `documentationOff = evalModule { documentation = "unset"; };` next
   to `noArchOn`.
2. Add the bindings `skillPath`, `skillFiles`, `skillText`, and `forbidden` with the exact
   values of `spec-eval-checks`.
3. Add the six checks `skillShipped`, `skillFilesExist`, `skillOmitted`, `skillIsGeneric`,
   `skillFrontmatter`, and `solutionExpertNamesSkill` with the conditions of the table of
   `spec-eval-checks`.
4. Add each of the six names to the `assert` list and to the `inherit` list of the result
   attribute set. Do not change the existing checks.
5. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
6. Make one negative test. Add the string `services/factory` to `SKILL.md` for the test, run the
   command of step 5 again, and confirm that the evaluation fails on `skillIsGeneric`. Then
   remove the string.
7. Run `git diff --check`.

## Check

The command of step 5 exits 0. The output has the six new names, each with the value `true`.
The negative test of step 6 fails with an assertion error. The command of step 7 reports no
error.
