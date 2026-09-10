# spec-role-template: Define the role body template

**Master:** [Specifications](README.md)
**Covers:** req-role-body-template
**Context:** context-factory

## Description

The file `references/role-template.md` of the `expert-role` skill gives the body template of an
implementation expert role. The template is the general shape of the shipped expert bodies of
the factory repository. The file ends with one filled example for a fictional component. An
agent copies the template, fills the parts for its component, and writes the result to
`utils/agent/role/<name>/ROLE.md`.

## Contract

The file `references/role-template.md` says, before the template: the body has no frontmatter
and no header. The shell adds the header. The body starts with the title line.

The template has seven parts, in this order:

| Part | Heading | Required content |
| --- | --- | --- |
| 1 | `# <Component> Expert` | One intro paragraph: "You are the implementation expert of the `<path>` component. You own phase 4 of the artifact-driven documentation model for this component. You give the solution expert the specifications and the tasks that touch this component in phases 2 and 3. You do not write requirements." |
| 2 | `## Read first` | `docs/wiki/documentation/artifact-driven/README.md`; the page in `docs/wiki/repo-arch/`; `docs/artifact/feat-<name>/tasks/` with the specifications and the requirements that each task covers; `AGENTS.md`. When `docs/domain/` exists: `docs/domain/context-<name>/README.md`. |
| 3 | `## Domain` | What the component is, its layout, and its conventions. |
| 4 | `## Procedure: phase 2 and 3, help the solution expert` | Read the requirements and the constraints. Write one `spec-<name>.md` for each contract that changes. Write one `task-<name>.md` for each unit of work. Give the files to the solution expert. Do not write `specifications/README.md` or `tasks/README.md`. |
| 5 | `## Procedure: phase 4, implementation` | Read the task and the specifications. Change the code. Add or update the tests. Run the checks. Report the changed files and the result of each check. |
| 6 | `## Rules` | The rules of the component. Do not repeat the rules of `AGENTS.md`. Write in ASD-STE-100 with the `asd-ste-100` skill. Do not change a requirement or a specification; report instead. |
| 7 | `## Output` | The changed files of the component. The result of the checks. In phases 2 and 3: the `spec-<name>.md` and `task-<name>.md` files of the component. |

The template has no status field and no phase-tracking field.

The file ends with one filled example under the heading `## Example`. The example:

- is for the fictional component `services/orders`, a Go service, with the role name
  `orders-expert`;
- starts with the title `# Orders Expert`;
- has each of the seven parts with the headings of the table;
- is 40 lines or fewer from its title line to the end of the file.

## Errors

The check `skillFilesExist` in `tests/eval.nix` fails if `references/role-template.md` does not
exist.
The check `skillIsGeneric` fails if the file names `services/factory`, `libs/nix`, or
`nix-instantiate`.
The agent reports an incomplete body when a filled body does not have the seven headings in
the order of the table.
