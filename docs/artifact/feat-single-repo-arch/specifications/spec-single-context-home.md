# spec-single-context-home: Define the bounded context rule

**Master:** [Specifications](README.md)
**Covers:** req-single-context-rule

## Description

The DDD assets give where a bounded context lives. Today they give the rule for the multiple
repositories architecture only. This specification adds the rule for the single repository
architecture next to it. The DDD module and the composition do not get a new block; the assets
state both rules.

## Contract

The rule: in the single repository architecture, one bounded context is one directory in
`src/`. A shared kernel or a published language is one directory in `src/` that two contexts
import.

The edits, one sentence for each architecture:

| File | Place | Edit |
| --- | --- | --- |
| `services/factory/domain/design/ddd/_assets/docs/wiki/design/ddd/README.md` | Section "Where a context lives" | The first list item gives both rules. The library item gives `libs/` for `multiple` and a directory in `src/` for `single`. |
| Same file | Procedure "add a bounded context", step 5 | Make `services/<name>/` in the multiple repositories architecture, or `src/<name>/` in the single repository architecture. |
| `services/factory/domain/design/ddd/_assets/docs/wiki/design/ddd/templates/domain/context-name/README.md` | `**Component:**` line | `services/<name> \| src/<name>` |
| `services/factory/composition/artifact-driven/_assets/ddd/docs/wiki/design/ddd/artifact-driven.md` | Phase 4 row | Code the model in the directory of the context: `services/<name>/` or `src/<name>/`. |
| `services/factory/composition/artifact-driven/_assets/ddd/agent/role/solution-expert/ROLE.md` | Phase 2 step 1, step 4, and the first rule | Each sentence gives both architectures. |
| `services/factory/composition/artifact-driven/_assets/ddd/AGENTS.md` | The DDD paragraph | Unchanged. This variant is for `multiple`. The `single` DDD variant is in `spec-single-composition`. |

## Errors

None. The edits are static text. The existing checks of the DDD module and the composition must
still pass.
