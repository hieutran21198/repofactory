# task-write-role-template: Write the role body template

**Plan:** [Implementation plan](README.md)
**Covers:** req-role-body-template, spec-role-template
**Context:** context-factory

## Goal

The file `references/role-template.md` of the skill gives the seven parts of a role body and
one filled example, as `spec-role-template` gives them.

## Steps

1. Write the statement before the template: the body has no frontmatter and no header, the
   shell adds the header, and the body starts with the title line. Do not write "the harness
   adds the header".
2. Write the seven parts of the template with the exact headings of the table of
   `spec-role-template`, in the order of the table.
3. Write the intro paragraph of part 1 with the exact text of `spec-role-template`.
4. Write the section `## Example` for the fictional component `services/orders`, a Go service,
   with the role name `orders-expert` and the title `# Orders Expert`. Give each of the seven
   parts.
5. Count the lines from the line `# Orders Expert` to the end of the file. Shorten the example
   until the count is 40 or fewer.
6. Check the generic-content rule of `spec-skill-files`. The file must not contain
   `services/factory`, `libs/nix`, `nix-instantiate`, or `_assets`. The file must not name a
   file of the factory repository. The file names only the allowed references of
   `spec-skill-files`.
7. Check the text against the core rules of the `asd-ste-100` skill.

## Check

The seven headings of the table of `spec-role-template` appear in the order of the table. The
example under `## Example` has the seven parts. The command
`sed -n '/^# Orders Expert$/,$p' references/role-template.md | wc -l` gives 40 or fewer. The
file has no status field and no phase-tracking field. The command
`grep -nE 'services/factory|libs/nix|nix-instantiate|_assets' references/role-template.md`
finds nothing.
