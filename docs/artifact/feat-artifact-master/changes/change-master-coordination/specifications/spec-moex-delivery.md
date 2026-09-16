# spec-moex-delivery: Deliver the mixture-of-experts wiki page

**Master:** [Specifications](README.md)
**Covers:** req-moex-nix-delivery
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The repository factory must copy the canonical mixture-of-experts page into each generated
repository that uses artifact-driven documentation.

The canonical file is:

`docs/wiki/documentation/mixture-of-experts/README.md`

The artifact-driven assets must contain these mirrors:

| Repository layout | Mirror |
| --- | --- |
| Single | `services/factory/composition/artifact-driven/_assets/single/docs/wiki/documentation/mixture-of-experts/README.md` |
| Multiple | `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md` |

The canonical page and both mirrors must change in one implementation task. After the change,
each mirror must have the same content as the canonical file. Each DDD variant must use the
mirror of its repository layout. It must not have a separate page mirror.

The single-layout and multiple-layout file sets must copy the applicable mirror to:

`docs/wiki/documentation/mixture-of-experts/README.md`

The entry must use `copyMode = "copy"`. It must apply when DDD is true or false.

These wiki indexes must contain the mixture-of-experts link:

- `docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/ddd/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/ddd/docs/wiki/README.md`

### Events

The delivery contract creates no runtime governance event. The `Repository blueprint composed`
event must include the generated page path and its source mirror.

### Data model

| Field | Rule |
| --- | --- |
| `canonical-page` | It identifies the authored wiki page. |
| `layout` | It is `single` or `multiple`. |
| `ddd` | It is true or false. |
| `source-mirror` | It identifies the mirror for the selected layout. |
| `target-path` | It is `docs/wiki/documentation/mixture-of-experts/README.md`. |
| `copyMode` | It is `copy`. |
| `index-link` | It points to the target path. |

All four layout and DDD combinations must produce the same page content. The produced content
must satisfy `spec-moex-page`.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each artifact-driven Repository blueprint supplies one current mixture-of-experts page. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The composition supplies generated files. |

## Description

The factory keeps one mirror for each repository layout. The DDD selection changes no page
content. The one-task rule prevents coordination guidance from differing between generated
repositories.

## Constraint resolutions

[`adr-master-coordination`](../decisions/adr-master-coordination.md) records the mirror constraint
and assigns owner selection to the artifact master.

## Errors

- A missing mirror fails the artifact-driven composition evaluation.
- A mirror that differs from the canonical file fails the evaluation.
- A change that updates fewer than all three page files fails the implementation check.
- A missing file entry or a different `copyMode` fails the evaluation.
- A missing index link fails the evaluation.
- Generated page content that fails `spec-moex-page` also fails this contract.
