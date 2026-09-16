# task-moex-pages: Update the mixture-of-experts pages

**Plan:** [Implementation plan](README.md)
**Covers:** req-expert-routing, req-moex-explanation, req-moex-nix-delivery, req-contract-driven-spec, req-parallel-implementation, spec-coordination-protocol, spec-moex-page, spec-moex-delivery, spec-contract-driven, spec-parallel-implementation
**Context:** context-factory
**Component:** `docs/wiki`, `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-nix-permissions
**can-parallel:** no
**Parallel reason:** The page must use the final role and permission contracts in the same context and aggregate.

## Goal

Give each repository layout the same self-contained explanation of the coordination routes.

## Owner selection

The artifact master must select one owner before this task starts. The owner must change the
canonical page, both mirrors, and the applicable evaluation checks together.

## Files

- `docs/wiki/documentation/mixture-of-experts/README.md`
- `services/factory/composition/artifact-driven/_assets/single/docs/wiki/documentation/mixture-of-experts/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md`
- `docs/wiki/README.md`
- The four single-layout and multiple-layout wiki index files in the artifact-driven assets.
- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Update the canonical English Markdown page.
2. Add the required `## Owner selection` section.
3. Add the required `## Governance events` section.
4. Define the artifact master as the only coordination and spawning owner.
5. State that the artifact master owns no phase content.
6. State that the solution expert calls no subagent and directly tasks no expert.
7. Explain the content owner of each phase and the phase 5 readiness gate.
8. Explain Plan-Pn then Build-Pn.
9. Contrast the chat-only `coordinate-plan` with the phase 3 `execution-plan`.
10. Explain contract-first authorship and master-routed feasibility review.
11. Explain solution-expert advice and artifact-master selection for an uncovered component.
12. Explain the option interview and its approval gate.
13. Explain phase 4 dependencies, `can-parallel`, ordered batches, spawning, and one commit.
14. Explain equal role-body rendering for OpenCode, Claude, and Codex.
15. Explain the OpenCode modes, declared task permissions, depth 1, and primary-agent selection.
16. Add a governance-event table with all routes from `spec-moex-page`.
17. Link to the related artifact-driven documentation.
18. Copy the canonical content to both repository-layout mirrors.
19. Keep each DDD variant on the mirror of its repository layout.
20. Keep the mixture-of-experts link in all five required wiki indexes.
21. Add Boolean evaluation assertions for the `## Owner selection` and
    `## Governance events` headings.
22. Assert all required governance-event names and routes.

## Check

1. Check every section, direct rule, harness, and event that `spec-moex-page` requires.
2. Check each route with more than two endpoints for a table or diagram.
3. Compare both mirrors with the canonical page. Each comparison must show equal content.
4. Check all five wiki indexes for the mixture-of-experts link.
5. Check that the page does not claim that Nix proves OpenCode runtime behavior.
6. Check that the page uses the term `declared permission` for the rendered configuration.
7. Check that the page does not give spawning or phase content to the wrong role.
8. Check the Boolean assertions for the two required headings and all governance events.
9. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
