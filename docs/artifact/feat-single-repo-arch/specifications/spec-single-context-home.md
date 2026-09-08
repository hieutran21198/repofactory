# spec-single-context-home: Define the bounded context rule

**Master:** [Specifications](README.md)
**Covers:** req-single-context-rule

## Description

The DDD assets give where a bounded context lives. Each DDD file that names an architecture has
one version for each architecture. The DDD module and the composition select the version of the
active architecture. The current contract is in the change
[spec-ddd-arch-trees](../changes/change-ddd-per-arch/specifications/spec-ddd-arch-trees.md) and
[spec-composition-arch-trees](../changes/change-ddd-per-arch/specifications/spec-composition-arch-trees.md).

## Contract

The rule: in the single repository architecture, one bounded context is one directory in
`src/`. A shared kernel or a published language is one directory in `src/` that two contexts
import.

The files that state the rule, in the `single` asset trees:

| File | Place |
| --- | --- |
| `services/factory/domain/design/ddd/_assets/single/docs/wiki/design/ddd/README.md` | Section "Where a context lives" and step 5 of the procedure "add a bounded context". |
| `services/factory/domain/design/ddd/_assets/single/docs/wiki/design/ddd/templates/domain/context-name/README.md` | `**Component:** src/<name>` |
| `services/factory/domain/design/ddd/_assets/single/docs/wiki/design/ddd/templates/domain/context-map.md` | The Component column. |
| `services/factory/composition/artifact-driven/_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md` | The phase 4 row. |
| `services/factory/composition/artifact-driven/_assets/single/ddd/agent/role/solution-expert/ROLE.md` | Phase 2 step 1, step 4, and the first rule. |
| `services/factory/composition/artifact-driven/_assets/single/ddd/AGENTS.md` | The DDD paragraph. |

The `multiple` asset trees state the rule of the multiple repositories architecture only.

## Errors

The check fails if a file of one architecture names the directory of the other architecture.
