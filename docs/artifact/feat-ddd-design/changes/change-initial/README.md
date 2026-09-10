# Change: Initial

**Feature:** [DDD design](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

Project teams need one method to find the boundaries of a system before they design the parts
inside each boundary. Without a method, each feature invents its own vocabulary and its own
boundaries. The teams then build components that overlap, and the agents that write the
artifacts cannot tell which component owns a rule.

Domain-driven design (DDD) gives this method. The strategic design finds the subdomains, the
bounded contexts, and the shared language. The tactical design then models the aggregates, the
commands, and the events inside each bounded context. The factory must offer DDD as a design
method, and the artifact-driven documentation model must use it when a project selects it.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
