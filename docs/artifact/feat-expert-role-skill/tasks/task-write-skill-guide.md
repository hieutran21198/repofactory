# task-write-skill-guide: Write SKILL.md of the expert-role skill

**Plan:** [Implementation plan](README.md)
**Covers:** req-self-contained-guidance, req-one-expert-per-component, req-result-check, spec-skill-location, spec-skill-files
**Context:** context-factory

## Goal

The skill folder of `spec-skill-location` exists and holds `SKILL.md` as `spec-skill-files`
gives it.

## Steps

1. Make the folder
   `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/`
   with the subfolder `references/`.
2. Write the frontmatter of `SKILL.md`: `name: expert-role`, then `description`. End the
   description with one sentence that starts with `Use for` and gives the three trigger phrases
   of `spec-skill-files`.
3. Write the section `## When to use` with the content of `spec-skill-files`: one expert for
   each component, one expert for each bounded context when `docs/domain/` exists, no second
   expert for a component that has one, and where to find the experts.
4. Write the section `## Procedure` with the five steps of `spec-skill-files`. In steps 2 and 4,
   write "the shell adds the header". Do not write "the harness adds the header".
5. Write the section `## Rules` with the seven rules of `spec-skill-files`.
6. Write the section `## References` with one link to `references/role-template.md` and one
   link to `references/role-builder.md`.
7. Check the generic-content rule of `spec-skill-files`. The file must not contain
   `services/factory`, `libs/nix`, `nix-instantiate`, or `_assets`. The file must not name a
   file of the factory repository. The file names only the allowed references of
   `spec-skill-files`.
8. Check the text against the core rules of the `asd-ste-100` skill.

## Check

The first three lines of `SKILL.md` are `---`, `name: expert-role`, and the `description` line.
The four headings `## When to use`, `## Procedure`, `## Rules`, and `## References` appear in
this order. The command
`grep -nE 'services/factory|libs/nix|nix-instantiate|_assets' <folder>/SKILL.md` finds nothing.
The section `## References` has the two links `references/role-template.md` and
`references/role-builder.md`.
