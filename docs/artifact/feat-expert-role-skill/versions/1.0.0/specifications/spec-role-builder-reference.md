# spec-role-builder-reference: Define the role declaration reference

**Master:** [Specifications](README.md)
**Covers:** req-role-declaration-reference, req-result-check
**Context:** context-factory

## Description

The file `references/role-builder.md` of the `expert-role` skill gives the fields of the option
`factory.domain.agent.role.builder.<name>`. It gives the rendered role file of each harness. It
gives one complete declaration for `devenv.local.nix`. The reference names the option path
only. It does not name the module file that declares the option.

The reference lists the fields of the option as they are today. A change to the role option in
the factory updates this reference in the same change. This is a rule for the factory
maintainer, not for the downstream agent.

## Contract

The file `references/role-builder.md` has these parts, in this order.

### Fields

The table of the fields of `factory.domain.agent.role.builder.<name>`:

| Field | Type | Default | Meaning |
| --- | --- | --- | --- |
| `enable` | bool | `true` | Whether to generate this role. |
| `name` | str | The attribute name | The file name of the role in each harness. |
| `description` | str | Required | Tells the harness when to use the role. |
| `instruction` | str | Required | The markdown body of the role file. |
| `harness.claude` | attrs | `{ }` | Extra frontmatter fields of `.claude/agents/<name>.md`. |
| `harness.codex` | attrs | `{ }` | Extra keys of `.codex/agents/<name>.toml`. |
| `harness.opencode` | attrs | `{ }` | Extra frontmatter fields of `.opencode/agents/<name>.md`. |

### Rendered files

The harness list is `factory.domain.agent.harness.uses`. It is a list with values from
`claude`, `codex`, and `opencode`. A harness that is not in the list renders no file. Each
rendered file has copy mode `copy`: the shell overwrites it on each entry.

| Harness | Rendered file | Content |
| --- | --- | --- |
| `claude` | `.claude/agents/<name>.md` | YAML frontmatter with `name` and `description` plus `harness.claude`, then the body. |
| `opencode` | `.opencode/agents/<name>.md` | YAML frontmatter with `description` plus `harness.opencode`, then the body. |
| `codex` | `.codex/agents/<name>.toml` | The keys `name`, `description`, and `developer_instructions` (the body) plus `harness.codex`. |
| `codex` | `.codex/config.toml` | One entry `agents.<name>` with `description` and `config_file = "agents/<name>.toml"`. |

### Declaration

One complete snippet for `devenv.local.nix`:

```nix
{
  factory.domain.agent.role.builder.<name> = {
    description = "<What the expert does. Use for ...>";
    instruction = builtins.readFile ./utils/agent/role/<name>/ROLE.md;
    harness.opencode.mode = "subagent";
  };
}
```

The reference says, after the snippet:

- `harness.opencode.mode = "subagent"` is the convention of each shipped role.
- An agent that copies the snippet and changes only `<name>`, the description, and the body
  gets a rendered role file in each harness in use after the next shell entry.

## Errors

The check `skillFilesExist` in `tests/eval.nix` fails if `references/role-builder.md` does not
exist.
The check `skillIsGeneric` fails if the file names `services/factory`, `libs/nix`, or
`nix-instantiate`.
Nix evaluation fails if a declaration sets a field that the option does not have, or does not
set `description` or `instruction`.
Nix evaluation fails if `builtins.readFile` does not find `utils/agent/role/<name>/ROLE.md`.
