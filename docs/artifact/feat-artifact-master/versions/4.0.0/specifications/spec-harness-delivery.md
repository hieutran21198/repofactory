# spec-harness-delivery: Deliver the roles to each harness

**Master:** [Specifications](README.md)
**Covers:** req-harness-delivery, req-expert-routing
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The repository factory must render each canonical built-in role body for each selected harness.
OpenCode, Claude, and Codex must receive the same instruction body for a given role. Harness
frontmatter and other declaration data can differ. Declaration data must not change the role
contract.

The factory must render these built-in roles:

- `artifact-master`
- `requirement-expert`
- `solution-expert`
- `artifact-release-expert`

The solution-expert body must state that the solution expert calls no subagent. It must tell the
solution expert to send feasibility-review and owner-selection requests to the artifact master.
It can name `expert-role` only when it tells the artifact master about that skill. It must not
tell the solution expert to load the skill or use it to create an expert.
Each tracked project-local implementation-expert body must state the no-subagent rule. It must
also state that the expert returns constraints only in phases 2 and 3. It must not tell the expert
to author specifications, decisions, or tasks.

OpenCode must render `artifact-master` with `mode = "all"`. The OpenCode user must select it as
the primary agent before coordination starts. OpenCode must render each factory-rendered content
expert with `mode = "subagent"`.

The canonical artifact-master body must state the OpenCode `allow`, explicit `deny`, and depth 1
declarations. It must also state that the user selects the artifact master as the primary agent.

The factory must declare all OpenCode task permissions in one location:
`harness.opencode.settings.agent.<role>.permission.task`. It must declare `allow` for
`artifact-master`. It must declare `deny` for each factory-rendered content expert. An absent task
permission is not a deny.

This declared-permission contract applies only to factory-rendered roles. It does not include the
project-local implementation experts.

The global OpenCode setting `subagent_depth` must be 1. The master runs as the selected primary
agent. Thus, depth 1 permits the master to start one content expert and prevents expert nesting.

`mkCoordinatorRole` must use `lib.recursiveUpdate` or a complete nested literal when it changes
the OpenCode mode. A shallow `//` update must not replace the nested OpenCode declaration. Task
permissions must not also occur in role frontmatter.

The artifact-master skill must tell an OpenCode user to select `artifact-master` as the primary
agent. Claude and Codex must load their rendered artifact-master role through the skill.

### Events

The delivery contract creates no runtime governance event. The `Repository blueprint composed`
event must include each rendered role path and its harness declaration.

### Data model

Each factory-rendered role declaration must contain this data:

| Field | Rule |
| --- | --- |
| Name | It is a unique role name. |
| Description | It gives the content or coordination boundary. |
| Instruction body | It contains the canonical role body and an applicable DDD chapter. |
| OpenCode mode | It is `all` for `artifact-master` and `subagent` for each factory-rendered content expert. |
| OpenCode task permission | The global settings declare `allow` for `artifact-master` and `deny` for each factory-rendered content expert. |

The rendered paths must be:

| Harness | Artifact-master path | Selection |
| --- | --- | --- |
| OpenCode | `.opencode/agents/artifact-master.md` | The user selects it as the primary agent. |
| Claude | `.claude/agents/artifact-master.md` | The skill delegates to it. |
| Codex | `.codex/agents/artifact-master.toml` | The skill delegates to it. |

The tracked project-local implementation-expert sources are:

| Role | Instruction body |
| --- | --- |
| `factory-expert` | `utils/agent/role/factory-expert/ROLE.md` |
| `nix-lib-expert` | `utils/agent/role/nix-lib-expert/ROLE.md` |

The artifact master must select the phase 4 owner for changes to these tracked role bodies. The
two project-local descriptions in the ignored `devenv.local.nix` file are local-only. They are
outside the versioned contract and the versioned checks.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each selected harness receives the same role behavior, and only the artifact master can spawn experts. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The factory supplies files to selected harnesses. |

## Description

The role body defines behavior. Harness declaration data defines selection and permission data.
This separation keeps one behavior contract while each harness uses its own file format.

## Constraint resolutions

[`adr-opencode-coordination-permissions`](../decisions/adr-opencode-coordination-permissions.md)
records the OpenCode configuration resolutions. [`adr-master-coordination`](../decisions/adr-master-coordination.md)
records the owner-selection resolution for project-local expert text.

## Errors

- If a selected harness has no rendered built-in role, fail the blueprint evaluation.
- If two harnesses receive different instruction bodies for the same built-in role, fail the evaluation.
- If the rendered OpenCode config does not explicitly deny a factory-rendered content expert, fail the evaluation.
- If the rendered OpenCode config does not allow the artifact master, fail the evaluation.
- If `subagent_depth` is not 1, fail the evaluation.
- If a factory-rendered content expert renders as a selectable coordinator, fail the evaluation.
- Verify each tracked project-local implementation-expert body by inspection. Do not inspect these bodies in the composition evaluation.
