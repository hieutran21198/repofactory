# spec-ddd-arch-trees: Define the DDD asset trees

**Master:** [Specifications](README.md)
**Covers:** req-single-context-rule

## Description

The module `services/factory/domain/design/ddd/default.nix` keeps one asset tree for each
repository architecture. It reads the option `repo-arch.use` to select the tree. It reads no
asset of another domain. This specification replaces `spec-single-context-home` of the feature.

## Contract

The asset layout:

```
services/factory/domain/design/ddd/_assets/
    docs/domain/README.md                                The neutral seeds.
    docs/domain/context-map.md
    docs/domain/glossary.md
    multiple/docs/wiki/design/ddd/README.md              The design guide. Names `services/`.
    multiple/docs/wiki/design/ddd/templates/domain/**    The templates. Component is `services/<name>`.
    single/docs/wiki/design/ddd/README.md                The design guide. Names `src/`.
    single/docs/wiki/design/ddd/templates/domain/**      The templates. Component is `src/<name>`.
```

The file declarations, by option values:

| `design.use` | `repo-arch.use` | Target | Source | Copy mode |
| --- | --- | --- | --- | --- |
| `ddd` | any | `docs/domain/README.md`, `docs/domain/context-map.md`, `docs/domain/glossary.md` | `_assets/docs/domain/<file>` | `seed` |
| `ddd` | `multiple` or `single` | `docs/wiki/design/ddd/README.md` | `_assets/<arch>/docs/wiki/design/ddd/README.md` | `copy` |
| `ddd` | `multiple` or `single` | `docs/wiki/design/ddd/templates` | `_assets/<arch>/docs/wiki/design/ddd/templates` | `copy` |
| `ddd` | `unset` | The three seeds only. | | |
| `unset` | any | None. | | |

The module has one `lib.mkIf` block for the neutral seeds and one `lib.mkIf` block for each
architecture, in one `lib.mkMerge`.

The two versions of the design guide are the same text, except in the section "Where a context
lives" and in step 5 of the procedure "add a bounded context":

| Version | Where a context lives | Step 5 |
| --- | --- | --- |
| `multiple` | One bounded context is implemented by one directory in `services/`. An application in `apps/` is a user interface over one or more contexts. A library in `libs/` holds only a shared kernel or a published language. | Make the directory `services/<name>/`. |
| `single` | One bounded context is implemented by one directory in `src/`. A shared kernel or a published language is one directory in `src/` that two contexts import. | Make the directory `src/<name>/`. |

Both versions keep the rule "A context does not read the data store of another context."

The two versions of the templates are the same files, except the `**Component:**` line of
`context-name/README.md` and the Component column of `context-map.md`: `services/<name>` in
`multiple`, `src/<name>` in `single`.

## Errors

Nix evaluation fails if a source path does not exist.
The check fails if the module emits a guide or a template when `repo-arch.use` is `unset`.
The check fails if the module emits a file when `design.use` is not `ddd`.
The check fails if a guide of one architecture names the directory of the other architecture.
