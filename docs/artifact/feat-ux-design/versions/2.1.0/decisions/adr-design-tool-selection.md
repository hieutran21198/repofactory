# adr-design-tool-selection: Use a closed selection with harness-owned MCP entries

**Relates to:** spec-design-tool, spec-pencil-mcp, spec-ux-design-option, spec-designer-expert
**Context:** context-factory

## Context

The design tool is optional. The factory needs one stable value for no tool and one value for
each supported adapter. The supported adapters are Figma and Pencil. Pencil means pen.dev with an
open `.pen` document and the MCP entry key `pencil`.

The design-tool domain declares only the passive selection. Each harness has a different MCP
format and output file. The composition must set only the internal UX Design signal.

The current feature version is `1.0.0`. The harness-owned MCP change exists in its change folder
and in code, but no `1.1.0` feature version exists. This change must not copy that unversioned
change as its source.

## Options

### Selection options

1. Use one enum with `unset`, `figma`, and `pencil`. Pro: The factory validates every value. Pro:
   One setting selects one adapter. Con: Each new adapter needs a factory change.
2. Use a free-text value. Pro: A maintainer can name a new tool without an enum change. Con: The
   factory cannot validate or supply an unknown adapter.
3. Use separate Boolean settings for Figma and Pencil. Pro: Each setting is small. Con: Both tools
   can become active and need a precedence rule.

### MCP ownership options

1. Let each harness module own its mergeable Figma and Pencil entries. Pro: The owner also owns
   the format and merge point. Con: Each harness needs adapter checks.
2. Let the artifact-driven composition own all MCP entries. Pro: One module holds all adapter
   values. Con: It writes across harness boundaries and can replace unrelated settings.
3. Let the design-tool module own all MCP entries. Pro: Adapter values stay near the selection.
   Con: The selection module must know each harness format and output file.

## Decision

Select selection option 1. Use `${namespace}.domain.design-tool.use` with `unset`, `figma`, and
`pencil`. Use `unset` as the default. A closed enum matches the adapters that the factory supplies.

Select MCP ownership option 1. Each harness module owns its mergeable Figma and Pencil entries.
The artifact-driven composition sets one internal UX Design signal. It writes no MCP entry.

Use `pencil` as the MCP entry key in all harnesses. The Pencil adapter uses only the local pen.dev
host and its open `.pen` document. It grants no remote endpoint or filesystem privilege.

Replace this ADR instead of adding another design-tool ADR. Two current ADRs for the same
selection and ownership would conflict.

Use `versions/1.0.0` as the artifact source. Replace only versioned artifacts that change. Add
`spec-pencil-mcp.md` as a new artifact for the harness-derived Pencil behavior. Do not copy or edit
files in `change-harness-mcp`.

Replace `spec-ux-design-option.md` and `spec-designer-expert.md`. Their `1.0.0` data models permit
only `unset` and `figma`. The replacements prevent a conflict with the three-value contract.

The Repository blueprint keeps the Domain model pattern. Its related option, harness, role, and
file invariants must stay consistent in one aggregate.

Use stdio for the Pencil MCP transport. The pen.dev setup supplies the portable command
`pencil` and connects it to the running local host. Claude uses `type = "stdio"`,
`command = "pencil"`, empty `args`, and empty `env`. OpenCode uses `type = "local"`,
`command = ["pencil"]`, and `enabled = true`. Codex uses `command = "pencil"` and empty `args`.

The entries contain no machine-specific path, document path, `url`, remote endpoint, or
filesystem permission. The user selects the target by opening the `.pen` document in pen.dev.

## Feasibility constraints and resolutions

| Review identifier | Constraint identifier | Statement | Evidence | Affected item | Responsible owner | Resolution |
| --- | --- | --- | --- | --- | --- | --- |
| UX-PENCIL-P2-01 | C-P1-01 | The contract states the Figma canonical value only. It states no canonical Pencil value, so the clause "reject a final same-name value that differs from its canonical adapter value" is not decidable for `pencil`. Add the canonical Pencil entry for each harness. | spec-design-tool.md:51-53 ("The active module must reject a final same-name value that differs from its canonical adapter value."); spec-design-tool.md:39-41 gives `npx -y figma-ui-mcp` and `FIGMA_UI_MCP_TARGET` and no Pencil equivalent. | Harness Pencil entries and their equality checks: `claude.mcp-servers.pencil`, `opencode.settings.mcp.pencil`, `codex.settings.mcp_servers.pencil`. | solution-expert (contract author) | Define one exact local stdio entry for each harness. Claude uses `type = "stdio"`, `command = "pencil"`, empty `args`, and empty `env`. OpenCode uses `type = "local"`, `command = ["pencil"]`, and `enabled = true`. Codex uses `command = "pencil"` and empty `args`. Each harness compares its final entry with this value. |
| UX-PENCIL-P2-02 | C-P2-01 | The contract gives the owner module, the mergeable setting, the rendered path, and the entry key, but no entry value. It must state the transport and the fields of the canonical local Pencil entry for each harness. A stdio command and a local URL are different file layouts; OpenCode also needs its server type (`local` or `remote`). Without this value, phase 4 cannot render the entry or write the equality check. | spec-pencil-mcp.md:20-26 (owner/setting/path/key only); spec-pencil-mcp.md:44 ("The canonical entry must connect to the local pen.dev host for the open `.pen` document."); contrast spec-harness-mcp.md:49-51, which fixes `npx -y figma-ui-mcp` and `FIGMA_UI_MCP_TARGET`. | `claude` `.mcp.json` `mcpServers.pencil`; `opencode` `.opencode/opencode.jsonc` `mcp.pencil`; `codex` `.codex/config.toml` `mcp_servers.pencil`. | solution-expert (contract author) | Use stdio and the portable pen.dev-supplied `pencil` command. Record every rendered field for Claude, OpenCode, and Codex. Add no machine path, document path, `url`, remote endpoint, or filesystem permission. Test the exact values and each equality check in the harness evaluation paths. |

## Consequences

An unsupported `use` value fails option evaluation. A new design tool needs an enum value and a
harness adapter. Each harness owns its MCP format, merge point, conflict check, and output.

The Pencil adapter needs a running local pen.dev host and an open `.pen` document. Their absence
does not block the Design artifact. The feature version does not depend on an unversioned artifact
copy from `change-harness-mcp`.
