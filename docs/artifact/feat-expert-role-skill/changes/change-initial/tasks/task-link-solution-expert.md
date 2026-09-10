# task-link-solution-expert: Point the solution expert to the skill

**Plan:** [Implementation plan](README.md)
**Covers:** req-solution-expert-hand-off, spec-solution-expert-link
**Context:** context-factory

## Goal

The base body of the shipped solution expert names the `expert-role` skill in the hand-off
bullet of `## Mixture of experts`.

## Steps

1. Open `services/factory/composition/artifact-driven/_assets/agent/role/solution-expert/ROLE.md`.
2. Find the last bullet of `## Mixture of experts`. It starts with
   `- If no expert covers a domain, write the part yourself.`
3. Replace this bullet with the exact new text of `spec-solution-expert-link`.
4. Change nothing else in the file.
5. Do not change `_assets/agent/role/requirement-expert/ROLE.md`,
   `_assets/multiple/ddd/agent/role/solution-expert/ROLE.md`, or
   `_assets/single/ddd/agent/role/solution-expert/ROLE.md`.
6. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.

## Check

`git diff` shows one changed bullet in the solution-expert body and no other change.
`grep -c expert-role` on the solution-expert body returns 1. `grep -c expert-role` on the
requirement-expert body returns 0. The command of step 6 exits 0 and shows `chapterAppended`
and `chapterOmitted` as `true`.
