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

When the value is `false`, every generated file must be byte-identical to the file before this
feature. The factory must not add the designer expert, an OpenCode permission, a role chapter, a
Design template, or a design tool configuration.

When the value is `true`, a `lib.mkIf` composition merge must add these items:

- The designer expert in `role.builder`.
- The OpenCode task-permission denial for the designer expert.
- The optional UX Design chapters for the applicable built-in roles.
- The Design template.
- The harness-specific MCP setting when `use` is `figma`.

The role renderer must keep its existing subagent default. The composition must keep the five
existing phases.

The implementation must not edit these always-copied assets:

- `AGENTS.md`.
- `docs/wiki/documentation/artifact-driven/README.md`.
- `docs/wiki/documentation/mixture-of-experts/README.md`.

The enabled branch must use conditional files and optional role chapters instead.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| UX Design enabled | Repository blueprint | Repository maintainer, artifact master | The enable value, the `use` value, each generated role path, and each Design template path. |
| Repository blueprint composed | Repository blueprint | Repository maintainer | The selected options and the generated file paths. |

The aggregate must not create `UX Design enabled` when the setting is `false`.

### Data model

| Field | Type | Rule |
| --- | --- | --- |
| `enable` | Boolean | The default is `false`. |
| `use` | `unset` or `figma` | The design tool setting does not enable UX Design. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | An off selection keeps every generated file byte-identical. An on selection adds UX Design only to phase 2. |
| Upstream to downstream | None. The setting and its output stay in `context-factory`. |
| Component | `services/factory` |

## Description

This contract makes UX Design an optional repository composition. The `use` setting is passive
when UX Design is off. Conditional output protects the byte-identical off state.

## Errors

- If the enable value is not Boolean, reject the repository options.
- If UX Design is off and a UX Design output occurs, fail the repository blueprint check.
- If UX Design is on and the designer expert is absent, fail the repository blueprint check.
