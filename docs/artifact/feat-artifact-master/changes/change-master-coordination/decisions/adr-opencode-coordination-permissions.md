# adr-opencode-coordination-permissions: Declare task permission for each role

**Relates to:** spec-harness-delivery, spec-coordination-protocol, spec-parallel-implementation, spec-verification-contract
**Context:** context-factory

## Context

OpenCode uses task permission for subagent calls. The current factory grants this permission to
the solution expert. The artifact master must own all spawning. The rendered role text and the
declared OpenCode config must agree.

## Options

1. Declare task permission `allow` only for the artifact master. Declare `deny` for each content
   expert. Pro: The declared config has one coordination owner. Pro: An absent key cannot enable a
   content expert by default. Con: All expert requests must pass through the artifact master.
2. Declare task permission `allow` for the artifact master and the solution expert. Pro: Existing
   direct reviews can continue. Con: Two roles can coordinate experts. Con: This conflicts with
   the no-subagent rule.
3. Declare no task permissions and use written instructions only. Pro: The config has fewer keys.
   Con: OpenCode can use its default permission. Con: The artifact master has no declared grant.

## Decision

Select option 1. For factory-rendered OpenCode roles, declare `allow` for `artifact-master` and
`deny` for each content expert. Keep all task-permission declarations in
`harness.opencode.settings.agent.<role>.permission.task`. Do not put task permissions in role
frontmatter.

Set `subagent_depth = 1`. Render the artifact master with `mode = "all"`. Render each content
expert with `mode = "subagent"`. The user must select the artifact master as the primary OpenCode
agent before coordination starts.

## Feasibility constraints and resolutions

| ID | Constraint | Responsible owner | Resolution |
| --- | --- | --- | --- |
| F1 | The artifact master must render with mode `all` and declared task permission `allow`. A shallow nested update can remove OpenCode declaration data. | `factory-expert` | Use `lib.recursiveUpdate` or a complete nested literal in `mkCoordinatorRole`. Assert the final mode and global-settings permission. |
| F2 | Each content expert needs mode `subagent` and explicit task permission `deny`. OpenCode treats an absent key as default-allow. | `factory-expert` | Generate a global-settings deny for every factory-rendered content expert. Assert each mode and deny. |
| F3 | The current config grants task permission to `solution-expert`. | `factory-expert` | Remove `agent.solution-expert.permission.task = "allow"`. Replace it with the generated explicit deny. |
| F4 | A depth of 2 permits nested expert calls. The master must run as the selected primary agent. | `factory-expert` | Set `subagent_depth = 1`. Require primary-agent selection in role and skill text. |
| F5 | Duplicate task-permission declarations can conflict. | `factory-expert` | Put every task permission only in `harness.opencode.settings.agent.<role>.permission.task`. |
| F7 | The evaluation needs role-text checks for the feasibility route, no-subagent rule, permissions, and depth. | `factory-expert` | Add role-text assertions for all four items. Also add rendered-config assertions for `allow`, explicit `deny`, and depth 1. |
| F10 | Permission wording must not claim runtime proof. The claim must apply only to factory-rendered roles. | Solution expert | Use the term declared permission. Scope the contract and checks to factory-rendered roles. |
| N9 | Nix can inspect rendered config but cannot prove OpenCode runtime behavior. | `factory-expert` | Make O5 a rendered-config assertion only. Use declared-permission wording. |
| N10 | An absent permission key is not a deny. | `factory-expert` | Require the value `deny` for each factory-rendered content expert. |
| N11 | The same-body rule applies to instruction bodies only. Harness frontmatter differs. | `factory-expert` | Compare instruction bodies after the harness declaration boundary. Permit frontmatter differences. |
| N12 | Task permission needs one configuration location. | `factory-expert` | Use global OpenCode settings. Do not put task permission in role frontmatter. |
| O5 | The evaluation must inspect the permissions that the rendered config declares. | `factory-expert` | Assert `allow` for the artifact master and explicit `deny` for each content expert in the rendered config. |

All constraints have one responsible owner and one resolution. F1 and F5 do not conflict. The
coordinator helper preserves nested role declaration data. The global settings remain the only
task-permission source.

## Consequences

The rendered config declares one spawning owner. The artifact master can start one content expert
when the user selects it as the primary agent. A content expert cannot use an absent task key as a
deny. Nix checks the declared config and does not claim to prove OpenCode runtime behavior.
