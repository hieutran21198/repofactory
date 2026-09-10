# Change: DDD assets per architecture

**Feature:** [Single repository architecture](../../README.md)
**From:** 1.0.0
**To:** 1.1.0
**Type:** Specifications

## Reason

The feature gave the home of a bounded context with one DDD file that states the rule of both
architectures. A project with one active architecture then gets text about the other
architecture in its design guide, its context template, its phase-mapping page, and its solution
expert. The project must get only the files of its active architecture. Each DDD file that names
an architecture gets one authored version for each architecture, and the module selects the
version by `repo-arch.use`.

## Artifacts

- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
