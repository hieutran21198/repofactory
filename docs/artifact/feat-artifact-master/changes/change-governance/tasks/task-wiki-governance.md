# task-wiki-governance: Update the governance pages and mirrors

**Plan:** [Implementation plan](README.md)
**Covers:** req-moex-explanation, req-moex-nix-delivery, req-expert-routing, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation, spec-moex-page, spec-moex-delivery, spec-release-role, spec-contract-driven, spec-interactive-recommend, spec-parallel-implementation
**Context:** context-factory
**Aggregate:** none
**Component:** `services/factory`
**Dependency:** task-templates
**can-parallel:** no
**Parallel reason:** This task changes `context-factory`, which the prior tasks also change.

## Goal

Make the canonical mixture-of-experts page and all mirrors agree with the governance contracts.

## Steps

1. Update the canonical mixture-of-experts page with all required sections and terms.
2. Add the role ownership table and the phase route table.
3. Identify the solution expert as the version gate only.
4. Identify the artifact release expert as the phase 5 content owner.
5. Explain contract-first review, the option interview, and parallel implementation.
6. Name all six governance events.
7. Explain canonical roles, rendered roles, harnesses, and the thin artifact-master skill.
8. Update the single-repository and multiple-repository page mirrors with equal content.
9. Update both DDD artifact-driven mirrors with the new phase 5 owner and version gate.
10. Keep the required page content self-contained.
11. Keep the link to the detailed artifact-driven documentation.

## Verify

1. Check every required section, term, role, route, harness, and event.
2. Check that each route with more than two endpoints uses a table or diagram.
3. Compare the canonical page with both repository-layout mirrors.
4. Check both DDD mirrors for the artifact release expert phase 5 route.
5. Check that no page says that the solution expert copies the version.
6. Check that each relative documentation link resolves in its repository layout.
