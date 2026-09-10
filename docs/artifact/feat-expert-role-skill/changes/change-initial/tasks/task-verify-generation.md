# task-verify-generation: Verify the generated skill and the hand-off

**Plan:** [Implementation plan](README.md)
**Covers:** req-skill-shipped-with-model, req-self-contained-guidance, req-one-expert-per-component, req-role-body-template, req-role-declaration-reference, req-result-check, req-solution-expert-hand-off, spec-skill-location, spec-skill-files, spec-role-template, spec-role-builder-reference, spec-solution-expert-link
**Context:** context-factory

## Goal

The skill and the hand-off render in this repository, and an agent sets up an expert from the
rendered skill alone.

## Steps

1. Enter the shell with `devenv shell`, or reload direnv, so that the shell renders the files.
2. List `.claude/skills/expert-role/` and `.agents/skills/expert-role/`. Run `diff -r` between
   each folder and the source folder
   `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/`.
3. Run `grep -l expert-role` on `.claude/agents/solution-expert.md`,
   `.opencode/agents/solution-expert.md`, and `.codex/agents/solution-expert.toml`.
4. Make the smoke test in a scratch folder outside the repository, for example under `$TMPDIR`:
   - Read only `.claude/skills/expert-role/SKILL.md`, `references/role-template.md`, and
     `references/role-builder.md`.
   - Draft `utils/agent/role/orders-expert/ROLE.md` and a `devenv.local.nix` snippet for the
     fictional component `services/orders` in the scratch folder.
   - Record each file that the procedure told you to open. Compare the record with the allowed
     references of `spec-skill-files`.
5. Optional: make the stronger smoke test. Add the declaration of `orders-expert` to `devenv.local.nix`
   of this repository with the body from the scratch folder. Enter the shell. Confirm that
   `.claude/agents/orders-expert.md`, `.opencode/agents/orders-expert.md`,
   `.codex/agents/orders-expert.toml`, and the entry `agents.orders-expert` in
   `.codex/config.toml` have the header and the body. Then remove the declaration and the
   scratch files, and enter the shell again.
6. Run `git diff --check`.
7. Run `git status`. Confirm that no rendered file and no scratch file is in the list.

## Check

Step 2 shows the three skill files in both skill folders, and `diff -r` reports no difference.
Step 3 lists the three solution-expert role files. The record of step 4 lists only files of a
downstream project and no file of the factory repository. Step 6 reports no error. Step 7
shows only the intended source changes under `services/factory/`.
