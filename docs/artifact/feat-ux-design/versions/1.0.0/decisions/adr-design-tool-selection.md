# adr-design-tool-selection: Use a closed design tool selection

**Relates to:** spec-design-tool, spec-ux-design-option
**Context:** context-factory

## Context

The design tool is optional. The factory needs a stable value for no tool and for each supported
adapter. The first supported adapter is Figma through `figma-ui-mcp`.

## Options

1. Use an enum with `unset` and `figma`. Pro: The factory can validate every value. Pro: The
   default has no external dependency. Con: Each new adapter needs a factory change.
2. Use a free text value. Pro: A maintainer can name a new tool without an enum change. Con: The
   factory cannot supply or validate an unknown adapter.
3. Use a Boolean Figma setting. Pro: The setting is small. Con: The name binds the model to one
   tool and does not extend to a second adapter.

## Decision

Select option 1. Add `${namespace}.domain.design-tool.use` with the values `unset` and `figma`.
Use `unset` as the default. A closed enum matches the adapters that the factory can supply.

The design-tool domain declares only `use`. The artifact-driven composition writes the MCP
settings. It branches on `harness.uses`, uses each harness-native key, and applies the
cross-domain values with `lib.mkForce`.

## Feasibility constraints and resolutions

| ID | Constraint | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- |
| UX-C-02-1 | Add `services/factory/domain/design-tool/default.nix` with `design-tool.use` `mkEnumOpt [unset figma]` default `unset`; importer auto-discovers; separate from `domain.design.use`. | `domain/design`, importer, `agg` line 72. | `spec-design-tool` declaration. | `factory-expert` | Declare only `use` in the auto-discovered design-tool domain module. Keep it separate from `domain.design.use`. |
| UX-C-02-2 | Figma MCP config is cross-domain: put in composition not `domain/design-tool` (declares only `use`); MCP keys write harness settings (other domain); cross-domain override uses `mkForce` in composition. | Composition line 385, harness defaults, and the cross-domain rule. | `spec-design-tool` placement. | `solution-expert + factory-expert` | Put all MCP adaptation in the artifact-driven composition. Use `lib.mkForce` for the cross-domain harness settings. |
| UX-C-02-3 | MCP key differs per harness, branch on `harness.uses`; Claude+OpenCode JSON, Codex TOML. | Harness Claude, Codex, and OpenCode defaults. | `spec-design-tool` harness mapping. | `solution-expert + factory-expert` | Use `mcpServers` for Claude JSON, `mcp` for OpenCode JSON, and `mcp_servers` for Codex TOML. Emit only selected harness settings. |
| UX-C-02-4 | Use one name: option is `use` not `designTool`; fix Data models using `designTool` while Interface uses `use`. | `req-design-tool`, `spec-design-tool`, and the naming rule. | Specification data models. | `solution-expert` | Use `use` in all specification interfaces, events, and data models. |

## Consequences

An unsupported value fails during option evaluation. The factory needs an enum and adapter change
for each new design tool. The composition owns the three harness mappings. The Design artifact
remains required without an adapter.
