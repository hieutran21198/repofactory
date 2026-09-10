# task-eval-checks: Add the evaluation checks of the model

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, req-sync-ignores-versions, spec-eval-checks, spec-template-tree, spec-wiki-model
**Context:** context-factory

## Goal

Two Nix check files hold the contracts of the roles, the guidance, the templates, and the wiki page.

## Steps

1. In `services/factory/composition/artifact-driven/tests/eval.nix`, `dddReviewContent`, replace
   the pattern `".*solution expert.*phases 2 and 3.*"` with
   `".*solution expert.*phases 2, 3, and 5.*"`.
2. In the same file, add the eight named assertions of table `### The composition check` of
   spec-eval-checks: `rolesNameVersions`, `solutionExpertHasPhaseFive`,
   `requirementExpertHasNoLegacyProcedure`, `roleTemplateHasNoRootTasks`, `agentsNameVersions`,
   `dddPageHasVersionRow`, `dddReviewNamesPhaseFive`, and `descriptions`. Read each source with
   `builtins.readFile` and test it with `builtins.match`. Read the description of `descriptions`
   from `configs.multipleOn.factory.domain.agent.role.builder.solution-expert.description`.
   Write `\|` as `\\|` in the pattern of `dddPageHasVersionRow`.
3. Add each of the eight names to the `assert` list and to the returned attribute set.
4. Make the new file `services/factory/domain/documentation/artifact-driven/tests/eval.nix`
   with the shape of `services/factory/domain/design/ddd/tests/eval.nix`: a local `lib` with
   `mkIf`, and `evalModule` that imports `../default.nix` with `documentation.use` set to
   `"artifact-driven"` and to another value.
5. In the new file, write the nine named checks of table `### The domain check` of
   spec-eval-checks: `filesOn`, `filesOff`, `sourcesExist`, `templateTree`,
   `legacyTemplatesAbsent`, `wikiHasPhases`, `changeTemplateHasHeader`,
   `featureTemplateHasVersion`, and `noStatusInTemplates`. The assets root is
   `../_assets/docs/wiki/documentation/artifact-driven/`.
6. In `noStatusInTemplates`, list the nine template files of `templateTree` and match each with
   `".*\\*\\*Status:\\*\\*.*"`. Do not read a generated file.
7. Add each of the nine names to the `assert` list and to the returned attribute set.

## Check

Run each command from the repository root. Each command returns the attribute set with every
value `true`.

- `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`
- `nix-instantiate --eval --strict services/factory/domain/documentation/artifact-driven/tests/eval.nix`
- `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
- `nix-instantiate --eval --strict services/factory/domain/design/ddd/tests/eval.nix`

Then run `git diff --check`.
