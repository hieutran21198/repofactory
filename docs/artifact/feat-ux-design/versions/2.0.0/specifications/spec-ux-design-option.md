# spec-ux-design-option: Enable UX Design

**Master:** [Specifications](README.md)
**Covers:** req-enable-flag
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The factory must implement the required `artifact-driven.ux-design.enable` setting at
`${namespace}.composition.artifact-driven.ux-design.enable`. It must declare the setting with
`_utils.mkBoolOpt` and `default = false`. The option declaration must render no file.

| Setting | Type | Default | Effect |
| --- | --- | --- | --- |
| `artifact-driven.ux-design.enable` | Boolean | `false` | Add UX Design to the Specs and ADRs phase when the value is `true`. |

The design-tool selection has these values:

| Value | Effect |
| --- | --- |
| `unset` | Select no external design tool. |
| `figma` | Select the existing Figma adapter. The value renders nothing by itself. |
| `pencil` | Select the pen.dev adapter for an open `.pen` document. The value renders nothing by itself. |

Each selected harness must use this MCP collection and entry key for Pencil:

| Harness | Format | MCP collection | Pencil entry key |
| --- | --- | --- | --- |
| Claude | JSON | `mcpServers` | `pencil` |
| OpenCode | JSON | `mcp` | `pencil` |
| Codex | TOML | `mcp_servers` | `pencil` |

When `enable` is `false`, every generated file must be byte-identical to its prior file. The
factory must not add a designer expert, permission, role chapter, Design template, or tool entry.

When `enable` is `true`, an enable-gated composition merge must add these items:

- The designer expert in `role.builder`.
- The OpenCode task-permission denial for the designer expert.
- The optional UX Design chapters for the applicable built-in roles.
- The Design template.
- The internal `domain.agent.harness.ux-design.enable` signal.

The composition must not add a harness MCP setting. Each harness module owns the Figma and Pencil
entries. The role renderer must keep its existing subagent default. The composition must keep the
five phases.

The implementation must not edit these always-copied assets:

- `AGENTS.md`.
- `docs/wiki/documentation/artifact-driven/README.md`.
- `docs/wiki/documentation/mixture-of-experts/README.md`.

The Pencil adapter must use only a local pen.dev host and its open `.pen` document. The enabled
composition must not grant a remote endpoint or filesystem privilege.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| UX Design enabled | Repository blueprint | Repository maintainer, artifact master | The enable value, `use` value, generated role paths, Design template paths, and active MCP paths. |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected options and generated file paths. |
| Design tool selected | Repository blueprint | Repository maintainer, designer expert | The selected `use` value, selected harnesses, and active MCP paths. |

The aggregate must not create `UX Design enabled` when `enable` is `false`. These events document
domain results. `services/factory` has no runtime event mechanism for the design-tool selection.

### Data model

| Field | Type | Rule |
| --- | --- | --- |
| `enable` | Boolean | The default is `false`. |
| `use` | `unset`, `figma`, or `pencil` | The design-tool selection does not enable UX Design. |
| `harness.ux-design.enable` | Boolean | This internal signal has the same value as `enable`. |
| Pencil server name | String or absent | The active Pencil adapter uses `pencil`. |
| Pencil access | Local open document or absent | The contract grants no remote or filesystem privilege. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | An off selection keeps every generated file byte-identical. An on selection adds UX Design only to phase 2. |
| Pattern | Domain model |
| Upstream to downstream | None. The setting and generated output stay in `context-factory`. |
| Component | `services/factory` |

### Checks

`services/factory/composition/artifact-driven/tests/eval.nix` must prove these items:

- The composition gives its enable value to the internal harness signal.
- The composition writes no Figma or Pencil MCP setting.
- The off output stays byte-identical and has no UX Design output.
- The on output keeps the role, permission, chapters, template, and five phases.

These harness checks must prove that the signal gates both tool adapters:

- `services/factory/domain/agent/harness/claude/tests/eval.nix`.
- `services/factory/domain/agent/harness/opencode/tests/eval.nix`.
- `services/factory/domain/agent/harness/codex/tests/eval.nix`.

The phase 4 tasks must run the composition check and all three harness checks.

## Description

This contract makes UX Design an optional repository composition. The composition gives its
enable value to the harness domain through one internal signal.

## Errors

- If `enable` is not Boolean, reject the repository options.
- If UX Design is off and a UX Design output occurs, fail the repository blueprint check.
- If UX Design is on and the designer expert is absent, fail the repository blueprint check.
