# spec-single-composition: Define the guidance variants of the composition

**Master:** [Specifications](README.md)
**Covers:** req-single-guidance

## Description

The artifact-driven composition owns the agent guidance and the knowledge indexes. When
`repo-arch.use` is `single`, it selects a single-repository variant of `AGENTS.md` and
`docs/wiki/README.md`. The knowledge index `docs/README.md` does not depend on the architecture,
so the composition reuses its existing sources.

## Contract

The block for `repo-arch.use == "single"` in
`services/factory/composition/artifact-driven/default.nix` selects the sources with `if`, in
the same shape as the block for `multiple`:

```nix
"AGENTS.md".source = lib.mkForce (if ddd then ./_assets/single/ddd/AGENTS.md else ./_assets/single/AGENTS.md);
"docs/README.md".source = lib.mkForce (if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md);
"docs/wiki/README.md".source = lib.mkForce (if ddd then ./_assets/single/ddd/docs/wiki/README.md else ./_assets/single/docs/wiki/README.md);
```

The new assets:

| File | Content |
| --- | --- |
| `_assets/single/AGENTS.md` | The read list with the single repository page and the artifact-driven page. One paragraph: keep the code in `src/`, the component tests in `tests/`, the deployment configuration in `deployment/`. The artifact paragraph of the `multiple` variant. |
| `_assets/single/docs/wiki/README.md` | The wiki index with `## Architecture` that links the single repository page and `## Documentation` that links the artifact-driven page. |
| `_assets/single/ddd/AGENTS.md` | The `single` variant plus the DDD pages in the read list and the DDD paragraph with the sentence "One bounded context is one directory in `src/`". |
| `_assets/single/ddd/docs/wiki/README.md` | The `single` wiki index plus the `## Design` section of the `multiple` DDD variant. |

The assets of the `multiple` architecture do not move.

The read list of `_assets/agent/role/solution-expert/ROLE.md` names the architecture page as
"the page in `docs/wiki/repo-arch/`, the components and the layout". One role text serves both
architectures.

## Errors

The check fails if the `single` block emits a file when `repo-arch.use` is `multiple`.
The check fails if the `multiple` block emits a file when `repo-arch.use` is `single`.
The check fails if a selected source does not exist.
