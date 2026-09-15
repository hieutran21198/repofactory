# task-moex-page: Write the mixture-of-experts page

**Plan:** [Implementation plan](README.md)
**Covers:** req-moex-explanation, req-moex-nix-delivery, spec-moex-page, spec-moex-delivery
**Context:** context-factory

## Goal

Write one self-contained wiki page and supply identical mirrors and index links for each repository layout.

## Files

- `docs/wiki/documentation/mixture-of-experts/README.md`
- `services/factory/composition/artifact-driven/_assets/single/docs/wiki/documentation/mixture-of-experts/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md`
- `docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/ddd/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/ddd/docs/wiki/README.md`

## Steps

1. Create the canonical English Markdown page at the specified path.
2. Add the eight sections that `spec-moex-page` specifies.
3. Define each required term at its first use.
4. Add the specified roles and ownership table.
5. Add the specified phase routing table.
6. Explain Plan-Pn then Build-Pn and the two kinds of plan.
7. Explain canonical role rendering for OpenCode, Claude, and Codex.
8. Explain how the `artifact-master` skill loads the rendered role.
9. Link to the related artifact-driven documentation.
10. Keep all required explanations in the page itself.
11. Copy the canonical content to the single-layout mirror.
12. Copy the canonical content to the multiple-layout mirror.
13. Do not add separate DDD page mirrors.
14. Add the specified Mixture of Experts link to all five wiki indexes.

## Check

- Confirm that the page has all eight required sections and all seven term definitions.
- Confirm that the page has four role rows and five phase rows.
- Confirm that the page names OpenCode, Claude, and Codex.
- Compare each mirror with the canonical page. Each comparison must show identical content.
- Confirm that all five indexes contain the exact link from `spec-moex-delivery`.
- Confirm that the page does not use an include, a transclusion, or an external content source.

## Errors

- If the page conflicts with a current role contract, report the conflict. Do not change the specification.
- A missing section, table row, mirror, or index link makes this task incomplete.
