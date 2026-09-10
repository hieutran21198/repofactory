# adr-skill-location: Ship the skill from the by-role skill folder of the solution expert

**Relates to:** spec-skill-location
**Context:** context-factory

## Context

The `expert-role` skill must reach each harness in use when the project selects the
artifact-driven documentation model, and no harness when the project does not select it. The
factory has three places that can hold a skill:

- The agent domain module has `factory.domain.agent.skill.builtins`. It ships `asd-ste-100` to
  every project, with or without the documentation model.
- The artifact-driven composition sets `factory.domain.agent.skill.general` inside the block
  that is active only when the model is on.
- The same block folds `loadRoleSkills ./_assets/agent/skill/by-role <roleName>` over the
  builtin roles. The folders `by-role/requirement-expert/` and `by-role/solution-expert/` exist
  and are empty.

The user rule is: prefer simple Nix. Copy a file or add an authored file. Do not add Nix code
when an existing path does the work.

## Options

1. Put the skill folder in
   `services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/`.
   Pro: the loader exists, so the change is three authored files and no Nix code. Pro: the
   skill is active only when the model is on, because the fold is inside the model block. Pro:
   the folder says which role owns the skill; the solution expert hands off to it in phase 2.
   Con: the skill is one level deeper in the asset tree than a direct entry.
2. Add `expert-role` to `factory.domain.agent.skill.builtins` in
   `services/factory/domain/agent/skill/default.nix`. Pro: one place lists all shipped skills.
   Con: a builtin skill is on for every project; the skill would then need an extra condition
   on `documentation.use`, and the agent domain must not know the documentation model.
   Con: a Nix change for one skill.
3. Add a direct entry `skill.general.expert-role = ./_assets/agent/skill/expert-role;` in the
   composition block. Pro: the path is visible in the module. Con: a Nix change that repeats
   what the fold already does. Con: the folder does not say which role owns the skill.

## Decision

Option 1. The loader exists, the skill belongs to the phase of the solution expert, and the
change needs no Nix code. This follows the rule "prefer simple Nix".

## Consequences

A skill for the requirement expert goes to `by-role/requirement-expert/<skill>/` in the same
way. The check in `tests/eval.nix` reads `skill.general.expert-role` and compares it with the
by-role path. A skill that a role of a different composition needs must get its own loader
call in that composition; the agent domain module does not change.
