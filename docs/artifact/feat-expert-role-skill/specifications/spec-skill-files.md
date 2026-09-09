# spec-skill-files: Define the files of the expert-role skill

**Master:** [Specifications](README.md)
**Covers:** req-self-contained-guidance, req-one-expert-per-component, req-result-check
**Context:** context-factory

## Description

The `expert-role` skill tells a coding agent how to set up an implementation expert role for
one component of a downstream project. The skill has three authored files: `SKILL.md`, the
body template, and the role declaration reference. The agent reads only files that the project
has. The skill never names the factory repository.

## Contract

The skill folder of `spec-skill-location` holds these files:

| File | Content |
| --- | --- |
| `SKILL.md` | The frontmatter, when to use the skill, the procedure, the rules, the references. |
| `references/role-template.md` | The body template of a role and one filled example. See `spec-role-template`. |
| `references/role-builder.md` | The fields of the role declaration and the rendered file of each harness. See `spec-role-builder-reference`. |

### Frontmatter of `SKILL.md`

`SKILL.md` starts with a YAML frontmatter with two keys, in this order:

```yaml
---
name: expert-role
description: <What the skill does.> Use for "add an expert", "set up an implementation expert", or "no expert covers this component".
---
```

The description says what the skill does. It ends with one sentence that starts with
`Use for` and gives the three trigger phrases above. This is the convention of the shipped
`asd-ste-100` skill.

### Sections of `SKILL.md`

The body has these sections, in this order:

| Section | Required content |
| --- | --- |
| `## When to use` | A project has one implementation expert for each component. When `docs/domain/` exists, the project uses domain-driven design and has one expert for each bounded context. This is the same rule: one bounded context is one component. Do not add a second expert for a component that has one. To find the experts, read `role.builder` in `devenv.local.nix` and the folders in `utils/agent/role/`. |
| `## Procedure` | The five steps below. |
| `## Rules` | The rules below. |
| `## References` | One link to `references/role-template.md` and one link to `references/role-builder.md`. |

The five steps of `## Procedure`:

1. Find the component. Read the page in `docs/wiki/repo-arch/`. When `docs/domain/` exists,
   read the `**Component:**` line of `docs/domain/context-<name>/README.md`. Make sure that no
   expert covers the component.
2. Write the body at `utils/agent/role/<name>/ROLE.md` from `references/role-template.md`.
   Write the body only. Do not write a frontmatter or a header. The shell adds the header.
3. Declare the role in `devenv.local.nix` as `references/role-builder.md` shows.
4. Enter the shell again. The shell renders the files when it starts. Check the rendered role
   file of each harness in `factory.domain.agent.harness.uses`:
   `.claude/agents/<name>.md` for `claude`, `.opencode/agents/<name>.md` for `opencode`,
   `.codex/agents/<name>.toml` and one `agents.<name>` entry in `.codex/config.toml` for
   `codex`. Each rendered file has the header that the shell adds and the body. A harness
   that is not in the list has no rendered file. A rendered file is not a source: to change it,
   change the body or the declaration, then enter the shell again.
5. Report the files that you wrote and the result of the check.

The rules of `## Rules`:

- The expert owns phase 4 for its component.
- The expert gives `spec-<name>.md` and `task-<name>.md` to the solution expert in phases 2
  and 3. The expert does not write `specifications/README.md` or `tasks/README.md`.
- The expert does not write requirements.
- The description of the role says what the expert does and ends with a sentence that starts
  with `Use for`.
- Write in ASD-STE-100 Simplified Technical English. Use the `asd-ste-100` skill.
- Do not repeat the rules of `AGENTS.md` in the body.
- Do not put a status field or a phase-tracking field in any file.

### Generic content

The three files name only files that a downstream project has:

| Allowed reference |
| --- |
| `AGENTS.md` |
| `docs/wiki/documentation/artifact-driven/README.md` |
| The page in `docs/wiki/repo-arch/` |
| `docs/artifact/feat-<name>/tasks/` |
| `docs/domain/`, when it exists |
| `devenv.local.nix` |
| `utils/agent/role/<name>/ROLE.md` |
| `.claude/agents/<name>.md`, `.opencode/agents/<name>.md`, `.codex/agents/<name>.toml`, `.codex/config.toml` |

None of the three files contains the strings `services/factory`, `libs/nix`,
`nix-instantiate`, or `_assets`. None of the three files names a file of the
factory repository. None of the three files tells the agent to fetch, clone, or open the
factory repository.

## Errors

The check `skillFilesExist` in `tests/eval.nix` fails if one of the three files does not exist.
The check `skillFrontmatter` fails if `SKILL.md` does not start with `---\nname: expert-role\n`.
The check `skillIsGeneric` fails if one of the three files contains `services/factory`,
`libs/nix`, or `nix-instantiate`.
The agent reports a missing rendered role file when a harness in use has no file after the
shell entry. The agent does not edit the rendered file.
