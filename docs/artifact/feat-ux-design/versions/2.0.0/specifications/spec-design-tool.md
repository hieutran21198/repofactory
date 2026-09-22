# spec-design-tool: Select an optional design tool

**Master:** [Specifications](README.md)
**Covers:** req-design-tool
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The factory must declare `${namespace}.domain.design-tool.use` in
`services/factory/domain/design-tool/default.nix`. It must use `_utils.mkEnumOpt` with these
values:

| Value | Effect |
| --- | --- |
| `unset` | Select no external design tool. |
| `figma` | Select the existing Figma adapter. The value renders nothing by itself. |
| `pencil` | Select the pen.dev adapter for an open `.pen` document. The value renders nothing by itself. |

The default must be `unset`. The design-tool domain must declare only `use`. It must emit no file
and no Model Context Protocol (MCP) setting. The module importer must auto-discover this module.
The setting must stay separate from `domain.design.use`.

The setting must not enable UX Design. An adapter requires a selected harness and the internal
`${namespace}.domain.agent.harness.ux-design.enable` signal. The signal must also be `true`.
Each harness module must own its mergeable adapter entries. The composition must set only the
internal signal, and it must write no MCP entry.

Each selected harness must use these MCP collections and entry keys:

| Harness | Format | MCP collection | Figma entry key | Pencil entry key |
| --- | --- | --- | --- | --- |
| Claude | JSON | `mcpServers` | `figma-ui-mcp` | `pencil` |
| OpenCode | JSON | `mcp` | `figma-ui-mcp` | `pencil` |
| Codex | TOML | `mcp_servers` | `figma-ui-mcp` | `pencil` |

The canonical Pencil entries must have these exact fields:

| Harness | Transport | Canonical entry fields |
| --- | --- | --- |
| Claude | stdio | `type = "stdio"`; `command = "pencil"`; `args = []`; `env = {}` |
| OpenCode | stdio through a local server | `type = "local"`; `command = ["pencil"]`; `enabled = true` |
| Codex | stdio | `command = "pencil"`; `args = []` |

The command value `pencil` is the portable launcher that the pen.dev setup supplies. It is not a
machine-specific path. When pen.dev starts, it connects the launcher to the running local host.
The local host supplies the open `.pen` document to the MCP server.

The canonical entries must contain no `url`, document path, repository path, remote endpoint, or
filesystem permission. OpenCode must contain no `environment` field. Codex must contain no `env`
field. Claude must use an empty `env` attribute set.

When `use` is `figma`, the existing Figma adapter behavior must stay unchanged. Each selected
harness must add `figma-ui-mcp` only when the internal signal is `true`. The canonical adapter
must run `npx -y figma-ui-mcp` and target Figma Desktop.

When `use` is `pencil`, the designer expert can use this chain:

`selected harness -> MCP entry pencil -> local pen.dev host -> open .pen document`

The Pencil adapter must operate only through the local pen.dev host and its open document. This
contract must not grant a remote endpoint or filesystem privilege. The factory checks the
selection and generated MCP entries. It does not check the tool availability or an operation.

Each harness module must add only its nested active entry. It must use no `lib.mkForce`. It must
preserve unrelated settings and differently named MCP entries. The active module must reject a
final same-name value that differs from its canonical adapter value.

The external design is working material. The Markdown Design artifact is the repository record.
The designer expert must produce the full Design artifact for all three `use` values. It must
also produce the artifact when a selected tool is unavailable or an operation fails.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected `use` value, selected harnesses, and generated MCP paths. |
| Design tool selected | Repository blueprint | Repository maintainer, designer expert | The selected `use` value, selected harnesses, transport, canonical entry fields, and active MCP paths. |
| Design completed | Designer expert | Artifact master | The Design artifact path and the selected `use` value. |

`Design completed` must not depend on a successful tool operation. These events document domain
results. `services/factory` has no runtime event mechanism for the design-tool selection.

### Data model

| Field | Type | Default | Rule |
| --- | --- | --- | --- |
| `use` | Enum | `unset` | The permitted values are `unset`, `figma`, and `pencil`. |
| Pencil server name | String or absent | absent | The active Pencil adapter uses `pencil`. |
| Pencil transport | stdio or absent | absent | Claude and Codex use stdio. OpenCode uses `type = "local"` with a stdio command array. |
| Pencil command | String or list, or absent | absent | The portable command is `pencil` with no arguments. |
| Pencil document | Open `.pen` document or absent | absent | The adapter uses only the document open in the local pen.dev host. |
| Pencil remote endpoint | Absent | absent | The adapter contract grants no remote access. |
| Pencil filesystem privilege | Absent | absent | The adapter contract grants no filesystem privilege. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | No `use` value, unavailable tool, or failed operation can block the required Design artifact. |
| Pattern | Domain model |
| Upstream to downstream | None. The selection, harness adapters, and designer expert stay in `context-factory`. |
| Component | `services/factory` |

### Checks

`services/factory/domain/design-tool/tests/eval.nix` must prove these items:

- The permitted values are `unset`, `figma`, and `pencil`.
- The default is `unset`.
- The design-tool domain declares only `use`.
- The design-tool module emits no file and no MCP setting.
- An unsupported value fails option evaluation.

These harness checks must prove the adapter gates, entry keys, preservation, and conflict errors:

- `services/factory/domain/agent/harness/claude/tests/eval.nix`.
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`.
- `services/factory/domain/agent/harness/codex/tests/eval.nix`.

The checks must also prove that the `figma` behavior stays unchanged. The phase 4 tasks must run
all four evaluation paths. Each harness check must compare the final `pencil` entry with its exact
canonical fields.

## Description

The enum gives the factory a closed set of supported adapters. A passive value cannot activate UX
Design. Each harness module adapts an active selection to its own format.

## Errors

- If `use` has an unsupported value, reject the repository options and list the permitted values.
- If a selected tool is unavailable, continue without the tool.
- If one tool operation fails, continue without that operation.
- Do not record a tool result as a business rule or constraint.
