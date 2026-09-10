# Change: Composition-owned artifact policy

**Feature:** [Accepted artifact issues](../../README.md)
**From:** 1.0.0
**To:** 1.1.0
**Type:** Specifications, Decisions

## Reason

The first implementation puts the artifact status policy in the project-management domain. That
policy belongs to the artifact-driven project-issues composition because it defines how
documentation, CI, and project management work together. A project-management provider selects
an adapter and keeps the target and credential settings of that adapter.

The integration also activates when compatible adapters are selected. Adapter selection must not
activate one composition. The composition needs an explicit enable option and must validate its
dependencies only when it is enabled.

## Artifacts

- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
