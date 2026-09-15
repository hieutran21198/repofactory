# adr-master-coordination: Use one coordination owner

**Relates to:** spec-coordination-protocol, spec-harness-delivery, spec-moex-page, spec-moex-delivery, spec-parallel-implementation, spec-verification-contract
**Context:** context-factory

## Context

Content experts currently call other experts for feasibility review and phase 4 work. Nested
coordination is unstable in OpenCode and uses more coordination messages. The requirements assign
all expert spawning and coordination to the artifact master.

## Options

1. Let the artifact master spawn and coordinate every expert. Pro: One role owns every route.
   Pro: The solution expert can focus on phase content. Con: Each expert exchange passes through
   the artifact master.
2. Let each content expert spawn the experts that it needs. Pro: A content owner can make a direct
   request. Con: Coordination has multiple owners. Con: Nested calls can fail in OpenCode.

## Decision

Select option 1. One coordination owner gives the harness one stable route. It also keeps phase
content ownership separate from coordination ownership.

The artifact master routes feasibility reviews, selects uncovered owners, and starts phase 4 work
batches. It does not change the content payload that it routes.

## Feasibility constraints and resolutions

| ID | Constraint | Responsible owner | Resolution |
| --- | --- | --- | --- |
| F6 | The artifact-master skill must tell an OpenCode user to select the artifact master as the primary agent. | `factory-expert` | Add a direct primary-agent selection instruction to the skill text. Keep the role body as the coordination source. |
| F8 | The canonical mixture-of-experts page and both repository-layout mirrors must change together. | Artifact master | Select one phase 4 owner for all three page files. Put the files in one task. Require byte-equality checks. |
| F9 | The two project-local implementation-expert bodies and their `devenv.local.nix` descriptions need one owner. | Artifact master | Select one phase 4 owner for all four text changes. Do not change `utils/` files in phase 2. |
| F11 | The `solutionExpertNamesSkill` assertion can become false if `expert-role` leaves the solution-expert body. | `factory-expert` | Keep the skill name only as a referral to the artifact master. If the name leaves, update or replace the assertion. |
| F12 | The feasibility review does not require a new decision option. | Solution expert | Keep the two existing coordination options. Apply the constraints to selected option 1. |

The artifact master's owner selections for F8 and F9 must occur before the applicable phase 4
tasks start. The selected owner must not split either file group between experts.

## Domain-artifact proposal

The current domain artifacts contain two old direct routes. A later authorized domain edit must
make these changes:

- Change the glossary meaning of implementation expert. State that it returns constraints only
  and never authors specifications or tasks.
- In the context canvas, route `Contract written` from the solution expert to the artifact master.
- In the context canvas, route `Constraint returned` from the implementation expert through the
  artifact master to the solution expert.

This phase 2 write does not change `docs/domain/`, as directed for this change.

## Consequences

The artifact master becomes the only coordination entry point. Content experts return phase
content or advice to the artifact master. The coordinator has more routing work. The content
ownership boundaries stay unchanged.
