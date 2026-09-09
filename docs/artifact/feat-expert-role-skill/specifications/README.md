# Specifications: Expert role skill

## Solution

The artifact-driven composition ships one skill, `expert-role`, as three authored files in the
by-role skill folder of the solution expert:
`services/factory/composition/artifact-driven/_assets/agent/skill/by-role/solution-expert/expert-role/`.
The loader that the composition already has puts the folder into
`factory.domain.agent.skill.general` when the documentation model is `artifact-driven`. The
agent skill module then copies the folder to the skill folder of each harness in use. No Nix
module changes.

The skill has `SKILL.md` and two reference files. `SKILL.md` says when a project needs an
implementation expert, gives the procedure, and gives the rules of the role. The reference
`role-template.md` gives the body template of the role with one filled example. The reference
`role-builder.md` gives the fields of the role declaration, the rendered role file of each
harness, and one complete `devenv.local.nix` snippet. The three files name only files that a
downstream project has. They do not name a file of the factory repository.

The base body of the shipped solution expert changes in one bullet. When no expert covers a
domain, the solution expert offers to set one up with the `expert-role` skill before it writes
the part itself.

The checks of the composition in `services/factory/composition/artifact-driven/tests/eval.nix`
verify the skill path, the three files, the generic content, the frontmatter, the absence of the
skill when the model is off, and the hand-off text of the solution expert.

The component that changes is `services/factory` (context-factory). The context canvas and the
aggregate canvas do not change: the messages and the component of the context are the same.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-skill-location](spec-skill-location.md) | Ship the skill through the by-role skill folder to each harness in use. | req-skill-shipped-with-model |
| [spec-skill-files](spec-skill-files.md) | Define the three files of the skill, the sections of `SKILL.md`, and the generic-content rule. | req-self-contained-guidance, req-one-expert-per-component, req-result-check |
| [spec-role-template](spec-role-template.md) | Define the body template of an implementation expert role and its filled example. | req-role-body-template |
| [spec-role-builder-reference](spec-role-builder-reference.md) | Define the reference of the role declaration and of the rendered role file of each harness. | req-role-declaration-reference, req-result-check |
| [spec-solution-expert-link](spec-solution-expert-link.md) | Change the hand-off bullet of the shipped solution expert. | req-solution-expert-hand-off |
| [spec-eval-checks](spec-eval-checks.md) | Check the skill and the hand-off in the composition evaluation. | req-skill-shipped-with-model, req-self-contained-guidance, req-solution-expert-hand-off |

## Decisions

- [adr-skill-location](../decisions/adr-skill-location.md)
