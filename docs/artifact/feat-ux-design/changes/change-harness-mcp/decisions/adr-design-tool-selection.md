# adr-design-tool-selection: Use a closed selection with harness-owned MCP settings

**Relates to:** spec-design-tool, spec-harness-mcp, spec-ux-design-option
**Context:** context-factory

## Context

The design tool is optional. The factory needs one stable value for no tool and one value for
each supported adapter. The first supported adapter is Figma through `figma-ui-mcp`.

The design-tool domain must declare only the tool selection. Each harness has a different MCP
format and output file. The solution needs a merge point that preserves settings from other
modules.

## Options

### Selection options

1. Use an enum with `unset` and `figma`. Pro: The factory validates every value. Pro: The default
   has no external dependency. Con: Each new adapter needs a factory change.
2. Use a free-text value. Pro: A maintainer can name a new tool without an enum change. Con: The
   factory cannot supply or validate an unknown adapter.
3. Use a Boolean Figma setting. Pro: The setting is small. Con: The name binds the model to one
   tool and does not extend to a second adapter.

### MCP ownership options

1. Let each harness module own its MCP setting and output file. Pro: The owner also owns the
   format and the merge point. Pro: The composition writes no harness setting. Con: The
   composition must set one internal activation signal.
2. Let the artifact-driven composition own all MCP settings. Pro: One module holds all adapter
   values. Con: It writes across harness boundaries. Con: Its forced values can replace unrelated
   settings.
3. Let the design-tool module own all MCP settings. Pro: The adapter values stay with the tool
   selection. Con: A selection module must know each harness format and output file.

## Decision

Select option 1 for the selection. Use `${namespace}.domain.design-tool.use` with the values
`unset` and `figma`. Use `unset` as the default.

Select option 1 for MCP ownership. Each harness module owns its mergeable `figma-ui-mcp` setting
and its rendered output. The artifact-driven composition sets one internal UX Design signal in
the harness domain. It writes no MCP setting.

Replace this ADR instead of adding a new ADR. The prior ADR assigned MCP ownership to the
artifact-driven composition. Keeping that text with a new ADR would leave two conflicting
decisions in the current version.

## Feasibility constraints and resolutions

| ID | Constraint | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- |
| UX-HM-P2-01 / C-DT-01 | The existing enum already has the required values, default, and no output. | `services/factory/domain/design-tool/default.nix:10-19`; `libs/nix/options/default.nix:40-45`. | `spec-design-tool` declaration. | `factory-expert` | Keep the declaration unchanged. Add its checks next to the design-tool module. |
| UX-HM-P2-01 / C-DT-02 | The `figma` value alone renders nothing. The adapter also needs the UX Design enable input. | `spec-design-tool.md:20-23`; `spec-harness-mcp.md:22-26`. | Design tool interface. | `solution-expert` | Define `use` as passive. Require the internal harness UX Design signal and a selected harness. |
| UX-HM-P2-01 / C-DT-03 | The tool chain and its six functions describe designer behavior. The design-tool module cannot prove them. | `spec-design-tool.md:25-41`; `req-design-tool.md:16-18`. | Design tool checks. | `solution-expert` | Keep the external adapter description. Limit factory checks to the selection and rendered adapter setting. |
| UX-HM-P2-01 / C-DT-04 | The design-tool module has no local evaluation check. The composition check is not the module owner. | No `domain/design-tool/tests/eval.nix`; `composition/artifact-driven/tests/eval.nix:1413-1425`. | Design tool checks. | `factory-expert` | Put the enum, default, declaration, and no-output checks in `domain/design-tool/tests/eval.nix`. |
| UX-HM-P2-01 / C-DT-05 | The factory has no runtime event mechanism. | `spec-design-tool.md:43-50`; `services/factory`. | Specification events. | `solution-expert` | Mark the events as domain documentation. Add no event mechanism task or check. |
| UX-HM-P2-02 / C-HM-01 | Claude has no mergeable project MCP option. Its existing setting renders only `.claude/settings.json`. | `spec-harness-mcp.md:18-20`; `domain/agent/harness/claude/default.nix:8-31`. | Claude MCP setting. | `factory-expert` | Add `claude.mcp-servers` as an attribute-set option. Render it under `mcpServers` in `.mcp.json`. |
| UX-HM-P2-02 / C-HM-02 | OpenCode and Codex have mergeable attribute options. The direct Claude file does not preserve other definitions. | Claude, OpenCode, and Codex harness modules; `spec-harness-mcp.md:28-29`. | MCP preservation invariant. | `factory-expert` | Use mergeable options for all three harnesses. Add one nested entry and use no `mkForce`. |
| UX-HM-P2-02 / C-HM-03 | Nix priority rules can replace a conflicting server value without an error. | `spec-harness-mcp.md:74`; `composition/artifact-driven/default.nix:444-463`; `composition/artifact-driven/tests/eval.nix:21`. | MCP conflict error. | `factory-expert` | When active, assert that the final merged entry equals the canonical entry. Test a different same-name value. |
| UX-HM-P2-02 / C-HM-04 | A harness module must not read a named composition option. That coupling prevents module reuse. | `spec-harness-mcp.md:22-26`; no composition reads under `services/factory/domain/`. | Adapter activation input. | `factory-expert` | Add the internal `domain.agent.harness.ux-design.enable` signal. Let the composition set it and the harness modules read it. |
| UX-HM-P2-02 / C-HM-05 | The ownership move can use the existing harness modules and importer. | `composition/artifact-driven/default.nix:219-260,444-447,461-463,485-491`; `libs/nix/_importer.nix`. | MCP ownership. | `factory-expert` | Remove the four composition write sites and their unused local values. Add one entry in each harness module. |
| UX-HM-P2-02 / C-HM-06 | The current MCP checks import only the composition and will fail after the move. | `composition/artifact-driven/tests/eval.nix:98-153,1591-1627`. | MCP checks. | `factory-expert` | Put condition, server, preservation, and conflict checks next to each harness module. Keep only the signal handoff check in the composition. |
| UX-HM-P2-02 / C-HM-07 | The three guards keep the off output byte-identical. | Claude, OpenCode, and Codex harness modules; `spec-ux-design-option.md:20-22,65`. | Off-state invariant. | `factory-expert` | Gate each module entry on harness selection, the internal enable signal, and `use = figma`. |

## Consequences

An unsupported `use` value fails option evaluation. A new design tool needs an enum value and a
harness adapter. Each harness owns its MCP format and output. The composition has no harness MCP
value.

The internal activation signal adds one domain option. Local harness checks must prove merge
preservation and conflict failure. The Design artifact remains required without an adapter.
