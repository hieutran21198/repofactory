# task-update-guidance: Update the seeded guidance pages

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, spec-guidance-pages
**Context:** context-factory

## Goal

The `AGENTS.md` sources, the DDD phase page, the `ddd-review` skill, and the docs-site page describe the change and version model.

## Steps

All paths are under `services/factory/composition/artifact-driven/`.

1. In `_assets/multiple/AGENTS.md`, replace the paragraph that starts with
   `Keep the requirements, the specifications, the decisions, and the tasks of each feature in`
   with the paragraph of section `### AGENTS.md, four sources` of spec-guidance-pages. The new
   paragraph names `docs/artifact/feat-<name>/`, `changes/change-<name>/`, and
   `versions/<version>/`.
2. Do step 1 in `_assets/single/AGENTS.md`.
3. Do step 1 in `_assets/multiple/ddd/AGENTS.md`.
4. Do step 1 in `_assets/single/ddd/AGENTS.md`.
5. In `_assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md`, replace the second
   paragraph of the intro (lines 7 and 8) with the paragraph of section `### DDD phase page, two
   sources` of spec-guidance-pages.
6. In the same file, table `## The phases`, replace the output cell of row `1 Requirements`, the
   output cell of row `2 Specifications`, and the output cell of row `3 Plan` with the cells of
   spec-guidance-pages. Each cell names `changes/change-<name>/`.
7. In the same file, replace row `5 Change` with this row:
   `| 5 Version | Solution expert | No DDD step. The version copies the feature artifacts only. | \`versions/<version>/\` |`
8. Do steps 5 to 7 in `_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md`. Do not
   change the row `4 Implementation` of either file.
9. In `_assets/agent/skill/ddd-review/SKILL.md`, `## Read first`, line 22, replace
   `- The feature artifacts in \`docs/artifact/\` that are in scope.` with the two-line item of
   section `### ddd-review skill` of spec-guidance-pages.
10. In the same file, `## Rules`, line 79, replace `- The solution expert owns phases 2 and 3.`
    with `- The solution expert owns phases 2, 3, and 5.`
11. In `docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md`, add the item of
    section `### Docs-site page` of spec-guidance-pages at the end of the list in
    `## Write pages that render`, after the item about `templates/`.
12. Do not change `default.nix` or `docs-site/default.nix`.

## Check

- `diff _assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md _assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md`
  shows only the row `4 Implementation`.
- `grep -rn "5 Change\|phases 2 and 3" _assets/` returns nothing.
- The checks `dddReviewContent`, `agentsNameVersions`, `dddPageHasVersionRow`, and
  `dddReviewNamesPhaseFive` pass:
  `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
- `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
  passes.
- Enter the shell. `AGENTS.md`, `docs/wiki/design/ddd/artifact-driven.md`,
  `.claude/skills/ddd-review/SKILL.md`, and `docs/wiki/documentation/artifact-driven/docs-site.md`
  are equal to their sources.
