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
| `unset` | Add no external design tool configuration. |
| `figma` | When UX Design is on, add the Figma MCP configuration for each selected harness. |

The default must be `unset`. The design-tool domain must declare only `use`. The module importer
must auto-discover its domain module. The setting is separate from `domain.design.use`.

The artifact-driven composition must own the cross-domain MCP configuration. It must branch on
`harness.uses` and write only the setting for each selected harness:

| Harness | Format | MCP key |
| --- | --- | --- |
| Claude | JSON | `mcpServers` |
| OpenCode | JSON | `mcp` |
| Codex | TOML | `mcp_servers` |

The composition must use `lib.mkForce` for each cross-domain harness setting. It must preserve
unrelated harness settings. It must not put MCP configuration in the design-tool domain.

The setting must not enable UX Design. MCP means Model Context Protocol. When UX Design is on and
`use` is `figma`, the designer expert should use this chain:

`selected harness -> MCP -> figma-ui-mcp -> Figma Desktop`

The integration can supply these capabilities:

- Inspect designs, components, and variables.
- Create frames, layouts, and components.
- Reuse components.
- Modify designs.
- Apply variables.
- Capture screenshots.

The external design is working material. The Markdown Design artifact is the repository record.
The designer expert must produce the full Design artifact when the value is `unset`. It must also
produce the artifact when the tool is unavailable or an operation fails.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The `use` value and each generated harness configuration path. |
| Design completed | Designer expert | Artifact master | The Design artifact path and the selected `use` value. |

`Design completed` must not depend on a successful tool operation.

### Data model

| Field | Type | Default | Rule |
| --- | --- | --- | --- |
| `use` | Enum | `unset` | The permitted values are `unset` and `figma`. |
| Harness MCP key | Harness-specific setting or absent | absent | The `figma` value names `figma-ui-mcp` and Figma Desktop. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | No `use` value or tool failure can block the required Design artifact. |
| Upstream to downstream | None. The harness adapter and the role stay in `context-factory`. |
| Component | `services/factory` |

## Description

The enum gives the factory a closed set of supported adapters. The composition adapts the value
to each harness format. The designer expert has the same artifact contract with or without an
adapter.

## Errors

- If `use` has an unsupported value, reject the repository options and list the permitted values.
- If `figma-ui-mcp` or Figma Desktop is unavailable, continue without the tool.
- If one tool operation fails, record no tool result as a business rule or constraint.
