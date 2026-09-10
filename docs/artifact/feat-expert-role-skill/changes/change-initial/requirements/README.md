# Requirements: Expert role skill

## Business need

A software team that uses the repository factory in its own project needs implementation
experts. The factory ships the requirement expert and the solution expert. It does not ship an
implementation expert, because an implementation expert knows one component of one project.
The solution expert of the project gives the specifications and the tasks of each component to
the implementation expert of that component.

Today, a coding agent that adds an implementation expert to a project must open the factory
repository. Only the factory repository gives the shape of a role body and the fields of a role
declaration. Only the factory repository gives the phase contract of an implementation expert.
This breaks the promise that a generated repository is self-contained.

A project that selects the artifact-driven documentation model must receive a skill. With the
skill, a coding agent sets up an implementation expert role for one component. The agent must do
this from the files in the project only. The solution expert must point to this skill when no
implementation expert covers a component.

## Scope

- In scope: One skill that the factory ships with the artifact-driven documentation model.
- In scope: Guidance on when a project needs an implementation expert.
- In scope: A body template for an implementation expert role, with one filled example.
- In scope: A reference of the role declaration and of the location of the rendered role file
  of each harness.
- In scope: A check of the result in each harness in use.
- In scope: A hand-off from the shipped solution expert to the skill.
- Out of scope: Guidance on how a project adds its own custom skills.
- Out of scope: A change to the requirement expert role.
- Out of scope: A change to how a harness renders a role.
- Out of scope: A status or a phase field in any file.

## Domain

| Subdomain | Type | Context | Actors | Events |
| --- | --- | --- | --- | --- |
| Repository factory | Core | context-factory | Project team, coding agent, solution expert | Artifact-driven model selected, implementation expert role added |

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-skill-shipped-with-model](req-skill-shipped-with-model.md) | A project that selects the artifact-driven documentation model must get the skill in each harness in use. | Must |
| [req-self-contained-guidance](req-self-contained-guidance.md) | An agent that follows the skill must not need a file outside the project. | Must |
| [req-one-expert-per-component](req-one-expert-per-component.md) | The skill must say when a project needs an implementation expert. | Must |
| [req-role-body-template](req-role-body-template.md) | The skill must give the body template of an implementation expert role with one filled example. | Must |
| [req-role-declaration-reference](req-role-declaration-reference.md) | The skill must give a reference of the role declaration and of the rendered role file of each harness. | Must |
| [req-result-check](req-result-check.md) | The skill must tell the agent how to check the rendered role file of each harness in use. | Must |
| [req-solution-expert-hand-off](req-solution-expert-hand-off.md) | The shipped solution expert must point to the skill when no implementation expert covers a component. | Must |

## Acceptance

A project with the artifact-driven documentation model and at least one harness in use has the
skill in the skill folder of each harness. An agent that follows the skill writes a role body and
a role declaration. The role renders as a role file in each harness in use. The agent does not
open a file outside the project. The shipped solution expert names the skill.
