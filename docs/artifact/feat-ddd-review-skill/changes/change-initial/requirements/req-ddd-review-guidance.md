# req-ddd-review-guidance: Review the DDD artifacts

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The `ddd-review` skill must review strategic context canvases, tactical aggregate artifacts, and
links from feature artifacts to the domain model. It must report each problem with the artifact,
the failed rule, evidence, and the owner of the phase that must resolve it.

## Acceptance criteria

- Given a context canvas, when the skill reviews it, then it checks the strategic fields and the component path for the selected architecture.
- Given an aggregate canvas, when the skill reviews it, then it checks the invariants, identity references, events, and policies.
- Given a feature artifact that names a context or aggregate, when the skill reviews it, then it checks that the named domain artifact exists.
- Given a problem, when the skill reports it, then it does not change an artifact or decide the domain model.

## Notes

The requirement expert owns phase 1. The solution expert owns phases 2 and 3.
