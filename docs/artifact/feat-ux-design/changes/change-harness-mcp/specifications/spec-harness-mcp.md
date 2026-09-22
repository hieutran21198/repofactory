# spec-harness-mcp: Let each harness own its Model Context Protocol setting

**Master:** [Specifications](README.md)
**Covers:** req-design-tool
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

Each harness module must own its Figma Model Context Protocol (MCP) setting and its rendered
output. The artifact-driven composition and the design-tool module must not write a harness MCP
setting.

`services/factory/domain/agent/harness/default.nix` must declare the Boolean signal
`${namespace}.domain.agent.harness.ux-design.enable` with `_utils.mkBoolOpt`. The option must have
`internal = true` and `default = false`. The artifact-driven composition must set this signal to
its UX Design enable value. A harness module must not read an option in the `composition`
namespace.

| Harness | Owner module | Mergeable setting | Rendered output |
| --- | --- | --- | --- |
| Claude | `services/factory/domain/agent/harness/claude/default.nix` | `domain.agent.harness.claude.mcp-servers."figma-ui-mcp"` | `.mcp.json` JSON |
| OpenCode | `services/factory/domain/agent/harness/opencode/default.nix` | `domain.agent.harness.opencode.settings.mcp."figma-ui-mcp"` | `.opencode/opencode.jsonc` JSON |
| Codex | `services/factory/domain/agent/harness/codex/default.nix` | `domain.agent.harness.codex.settings.mcp_servers."figma-ui-mcp"` | `.codex/config.toml` TOML |

The Claude module must declare `mcp-servers` with `_utils.mkAttrsOpt`. The value type must be
`lib.types.json`, and the default must be an empty attribute set. The module must render the option
as `files.".mcp.json".json.mcpServers`. The existing Claude `settings` option must continue to
render only `.claude/settings.json`. A factory module that adds a Claude MCP server must use
`mcp-servers`. It must not write `.mcp.json` directly.

Each harness module must add its setting only when all these conditions are true:

1. The repository selects the harness in `domain.agent.harness.uses`.
2. The internal `domain.agent.harness.ux-design.enable` signal is `true`.
3. The repository sets `domain.design-tool.use` to `figma`.

If one condition is false, the harness module must not add the `figma-ui-mcp` entry. The `use`
value is passive when the internal signal is `false`.

Each module must add only its nested `figma-ui-mcp` entry. It must not use `lib.mkForce`. The
module must preserve each unrelated harness setting and each MCP entry with a different name.

When all conditions are true, each harness module must compare the final merged entry with its
canonical entry. The repository evaluation must fail when the values are different.

Each harness module must configure the command `npx -y figma-ui-mcp`. It must set
`FIGMA_UI_MCP_TARGET` to `Figma Desktop`. OpenCode must set the server type to `local` and must
enable the server.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected `use` value, the selected harnesses, and each rendered MCP path. |

The event must list no MCP path for an unselected harness. It must list no MCP path when UX Design
is off or `use` is `unset`.

This event documents the domain result. `services/factory` has no runtime event mechanism. The
implementation plan must not add an event mechanism for this event.

### Data model

| Item | Claude | OpenCode | Codex |
| --- | --- | --- | --- |
| Server collection | `mcpServers` | `mcp` | `mcp_servers` |
| Server name | `figma-ui-mcp` | `figma-ui-mcp` | `figma-ui-mcp` |
| Command | `npx` | `["npx", "-y", "figma-ui-mcp"]` | `npx` |
| Arguments | `["-y", "figma-ui-mcp"]` | Part of `command` | `["-y", "figma-ui-mcp"]` |
| Environment field | `env` | `environment` | `env` |
| Target value | `Figma Desktop` | `Figma Desktop` | `Figma Desktop` |
| Enable field | Not used | `enabled = true` | Not used |

| Control field | Type | Default | Rule |
| --- | --- | --- | --- |
| `domain.agent.harness.ux-design.enable` | Boolean | `false` | The artifact-driven composition sets this internal signal. |
| `domain.design-tool.use` | Enum | `unset` | Only `figma` selects this adapter. |
| `domain.agent.harness.uses` | List of harness names | Empty list | Only a named harness can render its output. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Only an active, selected harness can add its MCP setting. The harness keeps all unrelated settings. |
| Upstream to downstream | None. The design-tool selection, the UX Design composition, and the harness adapters stay in `context-factory`. |
| Component | `services/factory` |

### Checks

Each harness module must have one local check:

| Harness | Check |
| --- | --- |
| Claude | `services/factory/domain/agent/harness/claude/tests/eval.nix` |
| OpenCode | `services/factory/domain/agent/harness/opencode/tests/eval.nix` |
| Codex | `services/factory/domain/agent/harness/codex/tests/eval.nix` |

Each local check must prove these items for its harness:

- The harness adds the canonical server only when all three conditions are true.
- The harness emits no module-owned server when one condition is false.
- The rendered output has the required format and path.
- An unrelated setting stays unchanged.
- An MCP entry with a different name stays unchanged.
- A different `figma-ui-mcp` value fails evaluation.

The Claude check must also prove that multiple `mcp-servers` entries render in one `.mcp.json`
file. The composition check must only check the internal signal handoff. It must not check or emit
a harness MCP setting.

## Description

The design-tool domain owns the passive tool selection. The composition owns UX Design
activation. Each harness module owns its format, merge point, and rendered file. This boundary
keeps harness-specific settings out of the artifact-driven composition.

## Errors

- If the final active `figma-ui-mcp` value differs from the canonical value, fail the repository evaluation.
- If no harness is selected, add no module-owned MCP setting.
- If UX Design is off, add no module-owned MCP setting.
- If `use` is `unset`, add no module-owned MCP setting.
