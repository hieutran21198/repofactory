# task-design-template: Add the designer role and Design template

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, req-phase-placement, req-designer-scope, req-ownership-boundary, req-parallel-workflow, req-design-output, spec-design-tool, spec-phase-placement, spec-designer-expert, spec-design-ownership, spec-parallel-design, spec-design-artifact
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-ux-design-composition
**can-parallel:** no
**Parallel reason:** This task supplies the authored sources that the shared composition reads.

## Goal

Supply the designer role, conditional workflow chapters, and Design template with one ownership contract.

## Files

- `services/factory/composition/artifact-driven/_assets/agent/role/designer-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/ux-design/agent/role/artifact-master/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/ux-design/agent/role/solution-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/ux-design/agent/role/artifact-release-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/ux-design/docs/wiki/documentation/artifact-driven/templates/change/design/README.md`

## Decisions

- `adr-designer-harness`
- `adr-design-artifact-placement`
- `adr-repository-blueprint-pattern`

## Steps

1. Write the body-only `designer-expert` role source.
2. Make the designer expert read the accepted Requirements, current Specs, current ADRs, design
   system, theme, and user interface components.
3. Make the designer expert design UX flow, layout, interaction, and components.
4. Require reuse when an existing component or token fits.
5. Require one reuse-failure reason for each new component, token, or variable.
6. Keep business behavior, domain rules, permissions, and constraints outside Design.
7. Make Requirements, Specs, and ADRs win each conflict with Design.
8. Make the designer expert call no subagent and directly task no expert.
9. Let the designer expert use `figma-ui-mcp` when available.
10. Require the full Design artifact when `use` is `unset` or the external tool fails.
11. Write the artifact-master chapter with Start Design work, Reconcile Design, and the phase 2 join.
12. Write the solution-expert chapter with the parallel work and constraint handoff.
13. Keep solution and Design artifact ownership separate.
14. Write the release chapter that adds `design/` to step 3 of the copy-only phase 5 procedure.
15. Add no sixth phase and no Design option.
16. Write the conditional Design template with its title and `**Change:**` line.
17. Add UX, Layout, Interaction, Components, and Design System in the specified order.
18. Add the Reused components, New components, Existing tokens, and Required additions tables.
19. Require controlling artifact references and design source references.
20. Keep styling in the existing design system and theme.
21. Keep required Markdown content independent of an external design tool reference.
22. Do not edit an existing base role body or the always-copied template source.

## Check

1. Confirm that each role source has the required ownership and no-subagent text.
2. Confirm that the master and solution chapters define parallel work and final reconciliation.
3. Confirm that the release chapter copies `design/` without changing the phase count.
4. Confirm that the template has the five required sections in order.
5. Confirm that the component and Design System tables have all required fields.
6. Confirm that the template contains the ownership and reuse rules.
7. Confirm that no authored source depends on a successful external tool operation.
8. Confirm that each optional chapter is body-only and starts with its UX Design heading.
9. Run `nix-instantiate --parse services/factory/composition/artifact-driven/default.nix` after all source paths exist.
10. Run the final role and template assertions in `task-ux-design-evals`.
