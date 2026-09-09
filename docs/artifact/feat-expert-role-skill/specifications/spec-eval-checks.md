# spec-eval-checks: Check the skill in the composition evaluation

**Master:** [Specifications](README.md)
**Covers:** req-skill-shipped-with-model, req-self-contained-guidance, req-solution-expert-hand-off
**Context:** context-factory

## Description

The check file `services/factory/composition/artifact-driven/tests/eval.nix` evaluates the
composition module with a stub `lib`. It gets six new named checks for the `expert-role`
skill. Each check is a boolean. The file asserts each check and exposes it in the result
attribute set.

The evaluation of the composition stops at `factory.domain.agent.skill.general`. The check of
the rendered targets `.claude/skills/expert-role/` and `.agents/skills/expert-role/` belongs
to the agent skill domain module, which this feature does not change.

## Contract

The check file adds one configuration:

```nix
documentationOff = evalModule { documentation = "unset"; };
```

The check file adds these bindings:

```nix
skillPath = ../_assets/agent/skill/by-role/solution-expert/expert-role;
skillFiles = [
  "SKILL.md"
  "references/role-template.md"
  "references/role-builder.md"
];
skillText = file: builtins.readFile (skillPath + "/${file}");
forbidden = [
  ".*services/factory.*"
  ".*libs/nix.*"
  ".*nix-instantiate.*"
];
```

The six checks:

| Check | Condition |
| --- | --- |
| `skillShipped` | For each of `configs.multipleOn`, `configs.multipleOff`, `configs.singleOn`, `configs.singleOff`, and `noArchOn`: `cfg.factory.domain.agent.skill.general.expert-role == skillPath`. |
| `skillFilesExist` | For each file in `skillFiles`: `builtins.pathExists (skillPath + "/${file}")`. |
| `skillOmitted` | `!(builtins.hasAttr "expert-role" (documentationOff.factory.domain.agent.skill.general or { }))`. |
| `skillIsGeneric` | For each file in `skillFiles` and each pattern in `forbidden`: `builtins.match pattern (skillText file) == null`. |
| `skillFrontmatter` | `builtins.match "---\nname: expert-role\n.*" (skillText "SKILL.md") != null`. |
| `solutionExpertNamesSkill` | `builtins.match ".*expert-role.*" (base "solution-expert") != null` and `builtins.match ".*expert-role.*" (base "requirement-expert") == null`. |

`skillShipped` covers the five configurations with the model on. The design method does not
change the result, because the skill fold is inside the model block only.

`skillOmitted` uses `or { }`. When the model is off, the agent block is `{ }`, so
`documentationOff.factory` may have no `domain.agent` attribute. The check does not fail on a
missing attribute.

The check file adds each of the six names to the `assert` list and to the `inherit` list of
the result attribute set. The existing checks do not change.

The check runs with:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix
```

The stub `lib` has `mapAttrs'`, `filterAttrs`, `foldl'`, and `nameValuePair`, so
`loadRoleSkills` evaluates without a change to the stub.

## Errors

Nix evaluation fails with an assertion error and names no result when one of the six checks is
false.
Nix evaluation fails if `skillPath` does not exist, because `loadRoleSkills` reads the folder
and `skillText` reads each file.
The command exits with a non-zero code in both cases.
