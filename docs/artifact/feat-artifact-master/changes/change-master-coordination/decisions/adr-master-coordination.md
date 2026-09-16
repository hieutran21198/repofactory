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
| F9 | The two tracked project-local implementation-expert bodies need one owner. The ignored `devenv.local.nix` descriptions are outside versioned scope. | Artifact master | Select one phase 4 owner for both tracked role-body changes. Do not change or check the local-only descriptions. |
| F11 | The `solutionExpertNamesSkill` assertion can become false if `expert-role` leaves the solution-expert body. | `factory-expert` | Keep the skill name only as a referral to the artifact master. If the name leaves, update or replace the assertion. |
| F12 | The feasibility review does not require a new decision option. | Solution expert | Keep the two existing coordination options. Apply the constraints to selected option 1. |

The artifact master's owner selections for F8 and F9 must occur before the applicable phase 4
tasks start. The selected owner must not split either tracked file group between experts.

## Domain-artifact resolution

The context canvas keeps `services/factory` as its component. It uses these master-routed events:

- `Contract written` enters from the solution expert.
- `Feasibility routed` goes to the implementation expert.
- `Constraint returned` enters from the implementation expert and goes to the solution expert.
- `Work sequenced` enters from the solution expert.
- `Work batched` goes to the implementation expert.

The glossary states that an implementation expert returns constraints only in phases 2 and 3. It
also states that the implementation expert does not author specifications, decisions, or tasks.
The glossary keeps the `Work batch` term.

## Consequences

The artifact master becomes the only coordination entry point. Content experts return phase
content or advice to the artifact master. The coordinator has more routing work. The content
ownership boundaries stay unchanged.
