# spec-single-composition: Define the guidance variants of the composition

**Master:** [Specifications](README.md)
**Covers:** req-single-guidance

## Description

The artifact-driven composition owns the agent guidance and the knowledge indexes. It keeps one
asset tree for each repository architecture. When `repo-arch.use` is `single`, it selects the
files of the `single` tree. The knowledge index `docs/README.md` does not depend on the
architecture, so the composition reuses its existing sources. The current asset layout is in the
change
[spec-composition-arch-trees](../../change-ddd-per-arch/specifications/spec-composition-arch-trees.md).

## Contract

The block for `repo-arch.use == "single"` in
`services/factory/composition/artifact-driven/default.nix` selects the sources with `if`, in
the same shape as the block for `multiple`:

```nix
"AGENTS.md".source = lib.mkForce (if ddd then ./_assets/single/ddd/AGENTS.md else ./_assets/single/AGENTS.md);
"docs/README.md".source = lib.mkForce (if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md);
"docs/wiki/README.md".source = lib.mkForce (if ddd then ./_assets/single/ddd/docs/wiki/README.md else ./_assets/single/docs/wiki/README.md);
```

The `single` assets:

| File | Content |
| --- | --- |
| `_assets/single/AGENTS.md` | The read list with the single repository page and the artifact-driven page. One paragraph: keep the code in `src/`, the component tests in `tests/`, the deployment configuration in `deployment/`. The artifact paragraph of the `multiple` variant. |
| `_assets/single/docs/wiki/README.md` | The wiki index with `## Architecture` that links the single repository page and `## Documentation` that links the artifact-driven page. |
| `_assets/single/ddd/AGENTS.md` | The `single` variant plus the DDD pages in the read list and the DDD paragraph with the sentence "One bounded context is one directory in `src/`". |
| `_assets/single/ddd/docs/wiki/README.md` | The `single` wiki index plus the `## Design` section of the `multiple` DDD variant. |
| `_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md` | The phase-mapping page. The phase 4 row names `src/<name>/`. |
| `_assets/single/ddd/agent/role/<role>/ROLE.md` | The DDD chapter of each role. The solution expert chapter names `src/`. |

The read list of `_assets/agent/role/solution-expert/ROLE.md` names the architecture page as
"the page in `docs/wiki/repo-arch/`, the components and the layout". One role text serves both
architectures.

## Errors

The check fails if the `single` block emits a file when `repo-arch.use` is `multiple`.
The check fails if the `multiple` block emits a file when `repo-arch.use` is `single`.
The check fails if a selected source does not exist.
