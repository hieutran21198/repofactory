# spec-designer-expert: Define the designer expert

**Master:** [Specifications](README.md)
**Covers:** req-designer-scope
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

When UX Design is on, the factory must add `designer-expert` to `builtinRoles` with a conditional
attribute set. The role body must be at
`services/factory/composition/artifact-driven/_assets/agent/role/designer-expert/ROLE.md`. It must
contain only the instruction body.

The existing `mkRole` renderer must render the role for each selected harness. Its existing
OpenCode declaration must supply `mode = "subagent"`. The enabled composition branch must add
declared OpenCode task permission `deny`. The artifact master must route the role in phase 2.
The designer expert must handle Start Design work from the artifact master.

The designer expert must:

1. Read the accepted Requirements from the phase 1 commit.
2. Read the current Specs and ADRs.
3. Read the existing design system, theme, and user interface components.
4. Design the UX flow, layout, interaction, and components.
5. Reuse each existing component or token that fits.
6. Define a new component or variable only when reuse does not fit.
7. Write only the Design artifact.

For an initial feature, the current Specs and ADRs are the phase 2 drafts. For a later change,
they include the current version and the phase 2 replacement drafts.

The designer expert must handle Reconcile Design before it emits `Design completed`.

For OpenCode, the role must have `mode = "subagent"` and declared task permission `deny`. The
role must call no subagent and directly task no expert in all harnesses.

The factory evaluation must add the designer expert to role lists for enabled fixtures only. The
existing off fixtures must keep their current role lists and exact comparisons.

### Events

| Event | Producer | Consumer | Required content |
| --- | --- | --- | --- |
| Design work routed | Artifact master | Designer expert | Change, phase 1 commit, input paths, output path, and the selected `use` value. |
| Specifications and decisions written | Solution expert, through artifact master | Designer expert | Each final phase 2 Spec and ADR path. |
| Design completed | Designer expert | Artifact master | The Design artifact path, covered Requirements, reused items, and required additions. |

### Data model

| Field | Rule |
| --- | --- |
| `role` | The value is `designer-expert`. |
| `phase` | The value is `2`. |
| `inputs.requirements` | It identifies the accepted Requirements. |
| `inputs.specifications` | It identifies the current Specs and phase 2 drafts. |
| `inputs.decisions` | It identifies the current ADRs and phase 2 drafts. |
| `inputs.designSources` | It identifies the existing design system, theme, and components. |
| `output` | It identifies one `design/README.md`. |
| `use` | The value is `unset` or `figma`. |

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | The designer expert uses fixed inputs, prefers reuse, and owns only the Design artifact. |
| Upstream to downstream | None. The expert routes stay in `context-factory`. |
| Component | `services/factory` |

## Description

The role is a phase 2 content owner. It is not a coordinator. The existing renderer supplies all
harness files. A new component or variable needs a recorded reason that shows why reuse does not
fit.

## Errors

- If an input path is absent, report the missing input to the artifact master.
- If the designer expert tries to coordinate another expert, stop that route.
- If the design does not record a source for a reused item, do not complete the Design artifact.
- If a new item has no reuse reason, do not complete the Design artifact.
