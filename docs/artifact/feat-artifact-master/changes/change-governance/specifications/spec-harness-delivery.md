# spec-harness-delivery: Deliver the roles to each harness

**Master:** [Specifications](README.md)
**Covers:** req-harness-delivery
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The repository factory must render the canonical artifact-master role for each selected harness.
It must render the built-in requirement-expert, solution-expert, and artifact-release-expert roles
for the same harnesses. It must supply the artifact-master skill with the same blueprint.

The canonical artifact-master role body is the source of phase control and phase messages. The
factory must render that body for OpenCode, Claude, and Codex when the harness is in use. The
rendered role can add harness declaration data only. It must not change the role body contract.

The artifact-master skill must not repeat the role body. It must identify the rendered role path
for the harness in use. It must tell the harness to load that role before coordination starts.
The skill must preserve role routing, phase order, approval gates, and the phase 4 rule.

OpenCode must supply the artifact master as a selectable coordinator role. All content experts,
including the artifact release expert, must stay subagents. Claude and Codex must supply all roles
as delegated roles and must supply the delegating skill.

### Events

The delivery contract creates no runtime domain event. The `Repository blueprint composed` event
must include the rendered paths of all built-in roles.

### Data model

Each built-in role declaration must contain this data:

| Field | Rule |
| --- | --- |
| Name | It is a unique built-in role name. |
| Description | It gives the owned phase content and the use condition. |
| Instruction | It contains the canonical role body and an applicable DDD chapter. |
| OpenCode mode | It is `all` for the artifact master and `subagent` for each content expert. |

The artifact release expert must use the role name `artifact-release-expert` in all harnesses.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each selected harness receives the same built-in role behavior from the Repository blueprint. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The factory supplies files to each selected harness. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| `mkRole` reads a canonical role body and appends an existing DDD chapter when one exists. | `services/factory` implementation owner |
| The current built-in role set has no artifact release expert. | `services/factory` implementation owner |
| The role renderer already supports OpenCode, Claude, and Codex declarations. | `services/factory` implementation owner |
| The artifact-master skill stays the only delegating coordination skill in this change. | `services/factory` implementation owner |
| Project-specific implementation experts remain outside the built-in role set. | Solution expert |

These constraints are assumptions from `services/factory/composition/artifact-driven/default.nix`
and its role assets.

## Errors

- If a selected harness has no rendered built-in role, fail the blueprint evaluation.
- If the skill has no path for a selected harness, fail the blueprint evaluation.
- If a rendered role changes its canonical contract, fail the blueprint evaluation.
- If a content expert renders as a selectable coordinator, fail the blueprint evaluation.
