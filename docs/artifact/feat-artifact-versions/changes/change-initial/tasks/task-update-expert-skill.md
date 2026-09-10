# task-update-expert-skill: Update the expert-role skill and the live expert bodies

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, spec-expert-role-skill
**Context:** context-factory

## Goal

The `expert-role` skill and the two implementation expert bodies of this repository tell an
implementation expert to read the tasks of a change and the current version of the feature.

## Steps

Steps 1 to 5 are under
`services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/`.
Steps 6 and 7 are under `utils/agent/role/`.

1. In `references/role-template.md`, replace lines 23 and 24, the Read first bullet that names
   the root folder `docs/artifact/feat-<name>/tasks/` as the tasks of the feature, with the three
   lines of section `### The role body template` of spec-expert-role-skill. The new bullet names
   `docs/artifact/feat-<name>/changes/change-<name>/tasks/` and `versions/<current>/`.
2. In `references/role-template.md`, replace line 77, the Read first line of the example that
   names `docs/artifact/feat-<name>/tasks/`, `AGENTS.md`, and the context README, with the one
   line of the same section. The line names
   `docs/artifact/feat-<name>/changes/change-<name>/tasks/`. Keep it on one line.
3. Make sure that the example in `references/role-template.md` keeps 40 lines or fewer from its
   title line to the end of the file. Do not change the seven headings or their order.
4. In `SKILL.md`, `## Rules`, add the rule of section `### The skill file` of
   spec-expert-role-skill after the rule about phases 2 and 3 (lines 45 and 46). The rule says
   that the expert reads the tasks of a change and the current version of the feature, and does
   not write in `versions/`.
5. Do not change the frontmatter of `SKILL.md`. The `name` stays `expert-role`.
6. In `factory-expert/ROLE.md`, replace lines 12 and 13, the Read first bullet that names the
   root folder `docs/artifact/feat-<name>/tasks/` as the tasks of the feature, with the three
   lines of section `### The implementation expert bodies of this repository` of
   spec-expert-role-skill. Do not change the rest of the body.
7. Do step 6 in `nix-lib-expert/ROLE.md`.
8. Do not edit the rendered role files under `.claude/agents/`, `.opencode/`, or `.codex/`.
   `devenv.local.nix` reads each body with `builtins.readFile`, and the shell renders them.

## Check

- `grep -rn "feat-<name>/tasks/" services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/ utils/agent/role/`
  returns nothing.
- `grep -rn "changes/change-<name>/tasks/" utils/agent/role/` returns one line in each of the two
  bodies.
- `grep -n "services/factory\|libs/nix\|nix-instantiate" SKILL.md references/*.md` in the skill
  folder returns nothing.
- The checks `skillIsGeneric`, `skillFrontmatter`, and `roleTemplateHasNoRootTasks` pass:
  `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
- Enter the shell. `.claude/skills/expert-role/references/role-template.md` is equal to the
  source. `.claude/agents/factory-expert.md` and `.claude/agents/nix-lib-expert.md` hold the new
  bullet.
