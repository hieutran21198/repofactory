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
| `figma` | Select the Figma adapter. This value renders nothing by itself. |

The default must be `unset`. The design-tool domain must declare only `use`. It must emit no file
and no Model Context Protocol (MCP) setting. The module importer must auto-discover the
design-tool module. The setting must stay separate from `domain.design.use`.

The setting must not enable UX Design. A harness adapter requires a selected harness and the
internal `${namespace}.domain.agent.harness.ux-design.enable` signal. The signal must also be
`true`. The `use` value must be `figma`.

When these inputs select the adapter, the designer expert can use this external chain:

`selected harness -> MCP -> figma-ui-mcp -> Figma Desktop`

The external adapter can supply these functions:

- Inspect designs, components, and variables.
- Create frames, layouts, and components.
- Reuse components.
- Change designs.
- Apply variables.
- Capture screenshots.

The external design is working material. The Markdown Design artifact is the repository record.
The designer expert must produce the full Design artifact when the value is `unset`. It must also
produce the artifact when the tool is unavailable or an operation fails.

The factory checks the adapter setting. It does not check the availability or the functions of
`figma-ui-mcp` or Figma Desktop.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected `use` value. |
| Design completed | Designer expert | Artifact master | The Design artifact path and the selected `use` value. |

`Design completed` must not depend on a successful tool operation.

These events document the domain result. `services/factory` has no runtime event mechanism. The
implementation plan must not add an event mechanism for these events.

### Data model

| Field | Type | Default | Rule |
| --- | --- | --- | --- |
| `use` | Enum | `unset` | The permitted values are `unset` and `figma`. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | No `use` value or tool failure can block the required Design artifact. |
| Upstream to downstream | None. The design-tool selection and the designer expert stay in `context-factory`. |
| Component | `services/factory` |

### Checks

`services/factory/domain/design-tool/tests/eval.nix` must check these items:

- The values are `unset` and `figma`.
- The default is `unset`.
- The design-tool domain declares only `use`.
- The design-tool module emits no file and no MCP setting.
- An unsupported value fails option evaluation.

## Description

The enum gives the factory a closed set of supported adapters. The passive value cannot activate
UX Design. The harness modules adapt an active selection to each harness format. The designer
expert has the same artifact contract with or without an adapter.

## Errors

- If `use` has an unsupported value, reject the repository options and list the permitted values.
- If `figma-ui-mcp` or Figma Desktop is unavailable, continue without the tool.
- If one tool operation fails, record no tool result as a business rule or constraint.
