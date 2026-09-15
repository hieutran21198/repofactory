# spec-moex-delivery: Deliver the mixture-of-experts wiki page

**Master:** [Specifications](README.md)
**Covers:** req-moex-nix-delivery
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The repository factory copies the mixture-of-experts page and its index link into each generated
repository that uses artifact-driven documentation.

## Contract

The canonical file is:

`docs/wiki/documentation/mixture-of-experts/README.md`

The artifact-driven assets must contain these mirrors:

| Repository layout | Mirror |
| --- | --- |
| Single | `services/factory/composition/artifact-driven/_assets/single/docs/wiki/documentation/mixture-of-experts/README.md` |
| Multiple | `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md` |

Each mirror must have the same content as the canonical file. The DDD variants must use the mirror
of their repository layout. They must not have a separate page mirror.

The multiple-layout files set in
`services/factory/composition/artifact-driven/default.nix` must contain this entry:

```nix
"docs/wiki/documentation/mixture-of-experts/README.md" = {
  source = ./_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md;
  copyMode = "copy";
};
```

The single-layout files set must contain this entry:

```nix
"docs/wiki/documentation/mixture-of-experts/README.md" = {
  source = ./_assets/single/docs/wiki/documentation/mixture-of-experts/README.md;
  copyMode = "copy";
};
```

The entries apply when `ddd` is true or false. This rule gives the page to these four
combinations:

| Repository layout | DDD selection | Page source |
| --- | --- | --- |
| Single | False | Single mirror |
| Single | True | Single mirror |
| Multiple | False | Multiple mirror |
| Multiple | True | Multiple mirror |

These index files must contain this link:

`- [Mixture of Experts](documentation/mixture-of-experts/README.md).`

- `docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/single/ddd/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/docs/wiki/README.md`
- `services/factory/composition/artifact-driven/_assets/multiple/ddd/docs/wiki/README.md`

The generated repository must contain a regular copied page. The copy must contain all content
that `spec-moex-page` requires. The delivery must use the existing wiki file pattern in the
artifact-driven composition.

## Errors

- A missing mirror fails the artifact-driven composition evaluation.
- A mirror that differs from the canonical file fails the evaluation.
- A missing file entry or a `copyMode` value other than `"copy"` fails the evaluation.
- A missing index link in any applicable wiki index fails the evaluation.
- A generated repository without the page or its index link fails the evaluation.
