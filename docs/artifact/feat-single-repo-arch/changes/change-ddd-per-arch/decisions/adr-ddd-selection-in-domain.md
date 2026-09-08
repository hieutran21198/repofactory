# adr-ddd-selection-in-domain: The DDD module selects the tree by the architecture option

**Relates to:** spec-ddd-arch-trees, adr-single-context-home

## Context

Each DDD file that names an architecture has one version for each architecture. A module must
select the version. The DDD module knows the design method. The repository architecture module
knows the architecture. The rule of the factory says that a domain does not read the assets of
another domain, and that a cross-domain override lives in a composition.

## Options

1. The DDD module reads the option `repo-arch.use` and selects its own asset tree. Pro: one
   module, two trees, no override. The module reads an option, not an asset of another domain.
   Con: the DDD module depends on the architecture option.
2. A new composition `composition/ddd/` combines the design method and the architecture, and
   emits the guide and the templates. The DDD module emits the neutral seeds only. Pro: the DDD
   module stays blind to the architecture. Con: one more module, and the design guide leaves the
   domain that owns it.
3. Keep one file that states both rules. Pro: no duplication. Con: the project gets text about
   an architecture that it does not use. Rejected by the project owner.

## Decision

Option 1. The DDD module reads `repo-arch.use` and selects the asset tree. The design guide
stays in the domain that owns it.

## Consequences

When `design.use` is `ddd` and `repo-arch.use` is `unset`, the module emits the neutral seeds
only. The project gets no design guide until it selects an architecture. The composition applies
the same rule to the DDD role chapters and the phase-mapping page.
