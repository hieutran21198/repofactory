# task-write-canonical-role: Write the canonical role

**Plan:** [Implementation plan](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, spec-coordination-protocol, spec-phase-messages
**Context:** context-factory

## Goal

Write the artifact-master role that controls one change and gives the user required phase messages.

## Files

- `services/factory/composition/artifact-driven/_assets/agent/role/artifact-master/ROLE.md`

## Steps

1. Add the phase order, committed-input rule, approval gate, routing, and phase commit rule.
2. Keep the coordination-only boundary and the `coordinate-plan` rule.
3. Add the required Plan-Pn fields and the rule for unknown fields.
4. Add the material-progress rule and the no-routine-message rule.
5. Add the Phase 4 start message and its phase 3 approval gate.
6. Add the required Build-Pn handoff fields and concise-message rule.

## Check

Read the role and check every rule in `spec-coordination-protocol` and `spec-phase-messages`.
