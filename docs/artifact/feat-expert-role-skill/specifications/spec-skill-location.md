# spec-skill-location: Ship the skill through the by-role skill folder

**Master:** [Specifications](README.md)
**Covers:** req-skill-shipped-with-model
**Context:** context-factory

## Description

The artifact-driven composition ships the `expert-role` skill. The skill is a folder of
authored files under the by-role skill folder of the solution expert. The composition loads
the folder into `factory.domain.agent.skill.general` when
`factory.domain.documentation.use` is `artifact-driven`. The agent skill domain module then
renders the folder into the skill folder of each harness in `factory.domain.agent.harness.uses`.

This specification adds no Nix code. The loader and the renderer exist. The decision is in
`decisions/adr-skill-location.md`.

## Contract

The skill folder is:

```text
services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/
├── SKILL.md
└── references/
    ├── role-template.md
    └── role-builder.md
```

The content of the three files is in `spec-skill-files`, `spec-role-template`, and
`spec-role-builder-reference`.

The composition module `services/factory/composition/artifact-driven/default.nix` keeps this
fold inside its `lib.mkIf (documentation.use == model)` block. The fold does not change:

```nix
skill.general = lib.foldl' (
  acc: roleName: acc // loadRoleSkills ./_assets/agent/skill/by-role roleName
) { } (builtins.attrNames builtinRoles);
```

`loadRoleSkills skillsDir roleName` is in `services/factory/composition/_utils.nix`. It returns
one entry `<entry> = skillsDir/<roleName>/<entry>` for each regular file or directory in
`skillsDir/<roleName>/`. It returns `{ }` when the folder does not exist. The builtin roles are
`requirement-expert` and `solution-expert`.

The result:

| `factory.domain.documentation.use` | `factory.domain.agent.skill.general.expert-role` |
| --- | --- |
| `artifact-driven` | `./_assets/agent/skill/by-role/solution-expert/expert-role` |
| Any other value | No entry |

The agent skill domain module `services/factory/domain/agent/skill/default.nix` renders each
entry of `skill.general` with `copyMode = "copy"`. The module does not change:

| Harness in `factory.domain.agent.harness.uses` | Target |
| --- | --- |
| `claude` | `.claude/skills/expert-role/` |
| `codex`, `opencode`, or both | `.agents/skills/expert-role/` |

The `copy` mode overwrites the target on each shell entry. Two harnesses in use get the same
source folder. A harness that is not in the list gets no target. A project that does not
select the model has no `expert-role` entry, so no harness gets the skill.

## Errors

Nix evaluation fails if the source folder does not exist when the model is on.
The check `skillShipped` in `tests/eval.nix` fails if `skill.general.expert-role` is not the
by-role path when the model is on.
The check `skillOmitted` fails if `skill.general` has an `expert-role` entry when the model is
off.
