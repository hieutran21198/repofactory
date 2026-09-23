# spec-designer-expert: Define the designer expert

**Master:** [Specifications](README.md)
**Covers:** req-designer-scope, req-design-tool
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

When UX Design is on, the factory must add `designer-expert` to `builtinRoles`. The role body must
be at `services/factory/composition/artifact-driven/_assets/agent/role/designer-expert/ROLE.md`.
It must contain only the instruction body.

The design-tool selection has these values:

| Value | Effect |
| --- | --- |
| `unset` | The designer expert works without an external design tool. |
| `figma` | The designer expert can use the existing Figma adapter. |
| `pencil` | The designer expert can use pen.dev with the open `.pen` document. |

Each selected harness must use this MCP collection and entry key for Pencil:

| Harness | Format | MCP collection | Pencil entry key |
| --- | --- | --- | --- |
| Claude | JSON | `mcpServers` | `pencil` |
| OpenCode | JSON | `mcp` | `pencil` |
| Codex | TOML | `mcp_servers` | `pencil` |

The existing `mkRole` renderer must render the role for each selected harness. Its OpenCode
declaration must supply `mode = "subagent"`. The enabled composition branch must add declared
OpenCode task permission `deny`. The artifact master must route the role in phase 2.

The designer expert must:

1. Read the accepted Requirements from the phase 1 commit.
2. Read the current Specs and ADRs.
3. Read the existing design system, theme, and user interface components.
4. Design the UX flow, layout, interaction, and components.
5. Reuse each existing component or token that fits.
6. Define a new component or variable only when reuse does not fit.
7. Write only the Design artifact.

For an initial feature, the current Specs and ADRs are the phase 2 drafts. For a later change,
they include the current version and the phase 2 replacement drafts.

When `use` is `pencil`, the designer expert may use only the local pen.dev host and the open
`.pen` document. It must not request remote access or filesystem privilege through this adapter.
The designer expert must handle Reconcile Design before it emits `Design completed`.

For OpenCode, the role must use subagent mode and declared task permission `deny`. The role must
call no subagent and directly task no expert in all harnesses.

The designer expert must produce the full Design artifact for `unset`. It must also produce the
artifact when Figma or Pencil is unavailable, no `.pen` document is open, or an operation fails.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Design tool selected | Repository blueprint | Designer expert | The selected `use` value, selected harnesses, and active MCP paths. |
| Design work routed | Artifact master | Designer expert | The change, phase 1 commit, input paths, output path, and selected `use` value. |
| Specifications and decisions written | Solution expert, through artifact master | Designer expert | Each final phase 2 Spec and ADR path. |
| Design completed | Designer expert | Artifact master | The Design path, covered Requirements, selected `use` value, reused items, and required additions. |

`Design completed` must not depend on tool availability or a successful tool operation. These
events document domain results. `services/factory` has no runtime event mechanism for tool use.

### Data model

| Field | Rule |
| --- | --- |
| `role` | The value is `designer-expert`. |
| `phase` | The value is `2`. |
| `inputs.requirements` | It identifies the accepted Requirements. |
| `inputs.specifications` | It identifies the current Specs and phase 2 drafts. |
| `inputs.decisions` | It identifies the current ADRs and phase 2 drafts. |
| `inputs.designSources` | It identifies the existing design system, theme, and components. |
| `output` | It identifies one `design/README.md`. |
| `use` | The value is `unset`, `figma`, or `pencil`. |
| Pencil server name | The active Pencil adapter uses `pencil`. |
| Pencil document | The local pen.dev host has the target `.pen` document open. |
| Pencil privilege | No remote or filesystem privilege is granted. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | The designer expert uses fixed inputs, prefers reuse, owns only Design, and completes Design without a tool. |
| Pattern | Domain model |
| Upstream to downstream | None. The expert routes and tool adapters stay in `context-factory`. |
| Component | `services/factory` |

### Checks

`services/factory/composition/artifact-driven/tests/eval.nix` must prove these items:

- The enabled output contains the designer expert for each selected harness.
- The OpenCode role uses subagent mode and task permission `deny`.
- The role contract accepts `unset`, `figma`, and `pencil`.
- The role requires the full Design artifact when a tool is absent or fails.
- The Pencil instructions permit only the local host and open `.pen` document.

These harness checks must prove the `pencil` entry key and gate:

- `services/factory/domain/agent/harness/claude/tests/eval.nix`.
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`.
- `services/factory/domain/agent/harness/codex/tests/eval.nix`.

The phase 4 tasks must run the composition check and all three harness checks.

## Description

The designer expert is a phase 2 content owner. It is not a coordinator. A new component or
variable needs a recorded reason that shows why reuse does not fit.

## Errors

- If an input path is absent, report the missing input to the artifact master.
- If the designer expert tries to coordinate another expert, stop that route.
- If no `.pen` document is open, continue without Pencil.
- If a tool operation fails, continue and produce the full Design artifact.
- If a new item has no reuse reason, do not complete the Design artifact.
