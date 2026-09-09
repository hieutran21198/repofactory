# task-write-role-builder-reference: Write the role declaration reference

**Plan:** [Implementation plan](README.md)
**Covers:** req-role-declaration-reference, req-result-check, spec-role-builder-reference
**Context:** context-factory

## Goal

The file `references/role-builder.md` of the skill gives the fields table, the rendered files
table, and the `devenv.local.nix` snippet of `spec-role-builder-reference`.

## Steps

1. Read the options of `roleModule` in `services/factory/domain/agent/role/default.nix`.
   Compare the type and the default of each option with the fields table of
   `spec-role-builder-reference`. If a row does not match the module, report it. Do not change
   the specification.
2. Write the section `### Fields` with the seven rows of the fields table of
   `spec-role-builder-reference`. Name the option path
   `factory.domain.agent.role.builder.<name>` only. Do not name the module file.
3. Write the section `### Rendered files`. Give the rule of `factory.domain.agent.harness.uses`,
   the copy mode `copy`, and the four rows of the table: `claude`, `opencode`, `codex`, and the
   `agents.<name>` entry in `.codex/config.toml`.
4. Write the section `### Declaration` with the complete snippet of
   `spec-role-builder-reference`. The snippet has
   `instruction = builtins.readFile ./utils/agent/role/<name>/ROLE.md;` and
   `harness.opencode.mode = "subagent";`.
5. Write the two notes after the snippet: the `subagent` mode is the convention of each shipped
   role, and an agent that changes only `<name>`, the description, and the body gets a rendered
   role file in each harness in use after the next shell entry.
6. Check the generic-content rule of `spec-skill-files`. The file must not contain
   `services/factory`, `libs/nix`, `nix-instantiate`, or `_assets`. The file must not name a
   file of the factory repository. The file names only the allowed references of
   `spec-skill-files`.
7. Check the text against the core rules of the `asd-ste-100` skill.

## Check

Each option of `roleModule` in `services/factory/domain/agent/role/default.nix` has one row in
the fields table with the same type and the same default. The three rendered file paths
`.claude/agents/<name>.md`, `.opencode/agents/<name>.md`, and `.codex/agents/<name>.toml`
match the `files` targets of the role module. The command
`grep -nE 'services/factory|libs/nix|nix-instantiate|_assets' references/role-builder.md`
finds nothing. The snippet evaluates in a `devenv.local.nix` when you replace `<name>`;
task-verify-generation runs this test.
