# task-update-roles: Update the requirement expert and solution expert roles

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, req-change-is-unit-of-work, req-semver-by-type, req-version-is-full-state, req-change-holds-deltas, spec-requirement-expert-role, spec-solution-expert-role
**Context:** context-factory

## Goal

The two role bodies, their DDD chapters, and their descriptions follow the change and version model.

## Steps

All paths are under `services/factory/composition/artifact-driven/`.

1. Replace the full text of `_assets/agent/role/requirement-expert/ROLE.md` with the text of
   section `### The role body` of spec-requirement-expert-role. The body has no section
   `## Change to a feature whose code exists`. The body does not contain the string `expert-role`.
2. Replace the full text of `_assets/agent/role/solution-expert/ROLE.md` with the text of section
   `### The role body` of spec-solution-expert-role. The body has the section
   `## Procedure: phase 5, version`. The body keeps the string `expert-role` in
   `## Mixture of experts`.
3. In `_assets/multiple/ddd/agent/role/requirement-expert/ROLE.md`, line 14, replace
   `Do these steps after step 3 of the procedure above.` with
   `Do these steps after step 7 of the procedure above.`
4. Do step 3 in `_assets/single/ddd/agent/role/requirement-expert/ROLE.md`.
5. In `_assets/multiple/ddd/agent/role/solution-expert/ROLE.md`, add this line at the end of
   `### Rules`:
   `- The domain model in \`docs/domain/\` has no version. Do not copy it into \`versions/\`.`
   Do not change the anchor sentence
   `Do these steps after step 2 of the phase 2 procedure above.` on line 14.
6. Do step 5 in `_assets/single/ddd/agent/role/solution-expert/ROLE.md`.
7. In `default.nix`, `builtinRoles`, line 267, replace the description of `requirement-expert`
   with the string of section `### The role description` of spec-requirement-expert-role.
8. In `default.nix`, `builtinRoles`, line 268, replace the description of `solution-expert` with
   the string of section `### The role description` of spec-solution-expert-role.
9. Make sure that each of the four chapter files still starts with `## Domain-Driven Design`.

## Check

- `grep -rn "feat-<name>/requirements/\|feat-<name>/specifications/\|feat-<name>/tasks/" _assets/agent/role/`
  returns nothing.
- The checks `chapterAppended`, `chapterHasHeading`, `solutionExpertNamesSkill`,
  `rolesNameVersions`, `solutionExpertHasPhaseFive`, `requirementExpertHasNoLegacyProcedure`,
  and `descriptions` pass:
  `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
- Enter the shell. `.claude/agents/requirement-expert.md` and `.claude/agents/solution-expert.md`
  hold the new bodies and the new descriptions. Do the same search in `.opencode/agents/` and
  `.codex/agents/` when the harness is in use.
