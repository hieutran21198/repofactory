# spec-composition-guidance: Define the DDD guidance of the composition

**Master:** [Specifications](README.md)
**Covers:** req-ddd-guidance, req-context-boundary-rule

## Description

The artifact-driven composition owns the agent guidance and the knowledge indexes. When
`design.use` is `ddd`, it selects a DDD variant of each of these files and emits one page that
maps the DDD steps to the five phases. The base documentation module does not change.

## Contract

In the block for `repo-arch.use == "multiple"`, the composition selects the source with `if`:

```nix
"AGENTS.md".source = lib.mkForce (if ddd then ./_assets/ddd/AGENTS.md else ./_assets/AGENTS.md);
"docs/README.md".source = lib.mkForce (if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md);
"docs/wiki/README.md".source = lib.mkForce (if ddd then ./_assets/ddd/docs/wiki/README.md else ./_assets/docs/wiki/README.md);
```

A new block for `documentation.use == "artifact-driven" && ddd` adds:

```nix
"docs/wiki/design/ddd/artifact-driven.md" = {
  source = ./_assets/ddd/docs/wiki/design/ddd/artifact-driven.md;
  copyMode = "copy";
};
```

The DDD variants:

| File | Addition |
| --- | --- |
| `AGENTS.md` | The design guide and the phase-mapping page in the read list. One paragraph: keep the domain model in `docs/domain/`, one bounded context per directory in `services/`, update the domain artifacts in the phase that owns them. |
| `docs/README.md` | A link to the domain model. |
| `docs/wiki/README.md` | A section `## Design` with the design guide and the phase-mapping page. |

The phase-mapping page `docs/wiki/design/ddd/artifact-driven.md` has:

1. A table with Phase, Owner, DDD step, Output for the five phases.
2. The section "How a feature artifact points to a domain artifact" with the table of
   `spec-artifact-references`.

## Errors

The check fails if the composition selects a DDD variant when `design.use` is not `ddd`.
The check fails if the phase-mapping page is emitted when `design.use` is not `ddd`.
