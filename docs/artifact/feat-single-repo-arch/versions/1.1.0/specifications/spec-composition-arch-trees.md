# spec-composition-arch-trees: Define the composition asset trees

**Master:** [Specifications](README.md)
**Covers:** req-single-guidance, req-single-context-rule

## Description

The artifact-driven composition keeps one asset tree for each repository architecture. Each tree
holds the agent guidance, the wiki index, the DDD role chapters, and the phase-mapping page of
that architecture. The knowledge index `docs/README.md` and the base roles do not depend on the
architecture and stay outside the trees. This specification replaces the asset paths of
`spec-single-composition`.

## Contract

The asset layout:

```text
services/factory/composition/artifact-driven/_assets/
    agent/role/<role>/ROLE.md                          The base roles.
    docs/README.md                                     The knowledge index.
    ddd/docs/README.md                                 The knowledge index with the domain model.
    <arch>/AGENTS.md                                   The guidance.
    <arch>/docs/wiki/README.md                         The wiki index.
    <arch>/ddd/AGENTS.md                               The guidance with the DDD pages.
    <arch>/ddd/docs/wiki/README.md                     The wiki index with the DDD pages.
    <arch>/ddd/docs/wiki/design/ddd/artifact-driven.md The phase-mapping page.
    <arch>/ddd/agent/role/<role>/ROLE.md               The DDD chapter of each role.
```

`<arch>` is `multiple` or `single`. `<role>` is `requirement-expert` or `solution-expert`.

The block for each architecture in `services/factory/composition/artifact-driven/default.nix`:

```nix
(lib.mkIf (documentation.use == model && repo-arch.use == "<arch>") {
  files = {
    "AGENTS.md".source = lib.mkForce (if ddd then ./_assets/<arch>/ddd/AGENTS.md else ./_assets/<arch>/AGENTS.md);
    "docs/README.md".source = lib.mkForce (if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md);
    "docs/wiki/README.md".source = lib.mkForce (if ddd then ./_assets/<arch>/ddd/docs/wiki/README.md else ./_assets/<arch>/docs/wiki/README.md);
  }
  // lib.optionalAttrs ddd {
    "docs/wiki/design/ddd/artifact-driven.md" = {
      source = ./_assets/<arch>/ddd/docs/wiki/design/ddd/artifact-driven.md;
      copyMode = "copy";
    };
  };
})
```

The block that emitted the phase-mapping page for every architecture is removed.

The role instruction is the base role, and when `design.use` is `ddd` and the file exists, a
newline and the chapter `_assets/<repo-arch.use>/ddd/agent/role/<role>/ROLE.md`. When
`repo-arch.use` is `unset`, no such file exists and the instruction is the base role.

The two versions of the phase-mapping page differ in the phase 4 row only: "Code the model in
`services/<name>/`" or "Code the model in `src/<name>/`". The two versions of the solution
expert chapter differ in three sentences: the component of a context, the place of a shared
kernel or a published language, and the first rule. The two versions of the requirement expert
chapter are the same text.

## Errors

The check fails if a block emits a file when its architecture is not active.
The check fails if a role gets a DDD chapter when `design.use` is not `ddd` or `repo-arch.use`
is `unset`.
The check fails if the phase-mapping page is emitted when `design.use` is not `ddd` or
`repo-arch.use` is `unset`.
The check fails if a selected source does not exist.
