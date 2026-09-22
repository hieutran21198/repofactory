# spec-pencil-mcp: Let each harness own its Pencil MCP entry

**Master:** [Specifications](README.md)
**Covers:** req-design-tool
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The design-tool selection has these values:

| Value | Effect |
| --- | --- |
| `unset` | Select no external design tool. |
| `figma` | Select the existing Figma adapter. The value renders nothing by itself. |
| `pencil` | Select the pen.dev adapter for an open `.pen` document. The value renders nothing by itself. |

Each harness module must own its mergeable Pencil MCP entry and rendered output:

| Harness | Owner module | Mergeable setting | Rendered output | Pencil entry key |
| --- | --- | --- | --- | --- |
| Claude | `services/factory/domain/agent/harness/claude/default.nix` | `domain.agent.harness.claude.mcp-servers.pencil` | `.mcp.json` under `mcpServers` | `pencil` |
| OpenCode | `services/factory/domain/agent/harness/opencode/default.nix` | `domain.agent.harness.opencode.settings.mcp.pencil` | `.opencode/opencode.jsonc` under `mcp` | `pencil` |
| Codex | `services/factory/domain/agent/harness/codex/default.nix` | `domain.agent.harness.codex.settings.mcp_servers.pencil` | `.codex/config.toml` under `mcp_servers` | `pencil` |

The Pencil MCP transport must be stdio. The pen.dev setup must supply the portable `pencil`
launcher. When pen.dev starts, it connects this launcher to the running local host. The local host
supplies the open `.pen` document.

The Claude entry at `mcpServers.pencil` must be exactly:

```nix
{
  type = "stdio";
  command = "pencil";
  args = [ ];
  env = { };
}
```

The OpenCode entry at `mcp.pencil` must be exactly:

```nix
{
  type = "local";
  command = [ "pencil" ];
  enabled = true;
}
```

The Codex entry at `mcp_servers.pencil` must be exactly:

```nix
{
  command = "pencil";
  args = [ ];
}
```

The command value must not be a machine-specific path. The entries must contain no `url`,
document path, repository path, remote endpoint, or filesystem permission. OpenCode must contain
no `environment` field. Codex must contain no `env` field. Claude must use an empty `env` set.

The artifact-driven composition must set only the internal
`${namespace}.domain.agent.harness.ux-design.enable` signal. It must not write a Pencil MCP
setting. The design-tool module must not write a Pencil MCP setting.

Each harness module must add its `pencil` entry only when all these conditions are true:

1. The repository selects the harness in `domain.agent.harness.uses`.
2. The internal `domain.agent.harness.ux-design.enable` signal is `true`.
3. The repository sets `domain.design-tool.use` to `pencil`.

If one condition is false, the module must not add its `pencil` entry. The module must add only
the nested entry. It must not use `lib.mkForce`. It must preserve unrelated settings and MCP
entries with different names.

When the adapter is active, each module must compare the final merged `pencil` entry with its
canonical local entry. A different final value must cause an evaluation error. The canonical
entry must connect to the local pen.dev host for the open `.pen` document.

The entry must contain no remote endpoint, document path, repository path, or filesystem
permission. The user selects the target document by opening it in pen.dev. The factory must not
select or open a document.

The `figma` value must keep the existing `figma-ui-mcp` entry unchanged. The `pencil` value must
not add `figma-ui-mcp`. The `figma` value must not add `pencil`.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected `use` value, selected harnesses, and each rendered MCP path. |
| Design tool selected | Repository blueprint | Repository maintainer, designer expert | The selected `use` value, selected harnesses, transport, canonical entry fields, and active MCP paths. |
| Design completed | Designer expert | Artifact master | The Design artifact path and the selected `use` value. |

The repository event must list no Pencil MCP path for an unselected harness. It must list no
Pencil MCP path when UX Design is off or `use` is not `pencil`.

These events document domain results. `services/factory` has no runtime event mechanism for the
design-tool selection. The implementation plan must not add an event mechanism.

### Data model

| Item | Claude | OpenCode | Codex |
| --- | --- | --- | --- |
| Server collection | `mcpServers` | `mcp` | `mcp_servers` |
| Server name | `pencil` | `pencil` | `pencil` |
| Transport | stdio | stdio with `type = "local"` | stdio |
| Command | `pencil` | `["pencil"]` | `pencil` |
| Arguments | `[]` | Part of `command` | `[]` |
| Environment | `{}` | Absent | Absent |
| Enabled | Not used | `true` | Not used |
| Connection scope | Local pen.dev host | Local pen.dev host | Local pen.dev host |
| Document | Open `.pen` document | Open `.pen` document | Open `.pen` document |
| Remote endpoint | Not permitted | Not permitted | Not permitted |
| Filesystem privilege | Not permitted | Not permitted | Not permitted |

| Control field | Type | Default | Rule |
| --- | --- | --- | --- |
| `domain.agent.harness.ux-design.enable` | Boolean | `false` | The artifact-driven composition sets this internal signal. |
| `domain.design-tool.use` | Enum | `unset` | Only `pencil` selects the Pencil adapter. |
| `domain.agent.harness.uses` | List of harness names | Empty list | Only a named harness can render its output. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Only an active, selected harness can add its local `pencil` entry, and the Design artifact is never blocked. |
| Pattern | Domain model |
| Upstream to downstream | None. The selection, UX Design composition, and harness adapters stay in `context-factory`. |
| Component | `services/factory` |

### Checks

Each harness module must have one local check:

| Harness | Check |
| --- | --- |
| Claude | `services/factory/domain/agent/harness/claude/tests/eval.nix` |
| OpenCode | `services/factory/domain/agent/harness/opencode/tests/eval.nix` |
| Codex | `services/factory/domain/agent/harness/codex/tests/eval.nix` |

Each local check must prove these items for its harness:

- The harness adds the canonical `pencil` entry only when all three conditions are true.
- The harness emits no module-owned `pencil` entry when one condition is false.
- The rendered output uses the required collection, entry key, format, and path.
- The rendered output has the exact canonical transport and fields for the harness.
- The entry contains no remote endpoint, document path, repository path, or filesystem permission.
- An unrelated setting stays unchanged.
- An MCP entry with a different name stays unchanged.
- A different final `pencil` value fails evaluation.
- The `figma` selection keeps the existing Figma entry and adds no `pencil` entry.

The Claude check must also prove that multiple MCP entries render in one `.mcp.json` file.
`services/factory/composition/artifact-driven/tests/eval.nix` must prove only the internal signal
handoff. The phase 4 tasks must run all four evaluation paths.

## Description

The design-tool domain owns the passive selection. The composition owns UX Design activation.
Each harness module owns its format, merge point, and rendered file.

## Errors

- If the final active `pencil` value differs from the canonical local value, fail evaluation.
- If pen.dev is not running, continue without the tool.
- If no `.pen` document is open, continue without the tool.
- If one Pencil operation fails, continue and produce the full Design artifact.
