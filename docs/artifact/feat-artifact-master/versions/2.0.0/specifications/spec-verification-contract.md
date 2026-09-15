# spec-verification-contract: Verify the coordination contract

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The factory evaluation tests the source text and the rendered output. The test contract proves that each harness receives the required coordination and communication instructions.

## Contract

The artifact-driven composition evaluation must check that the canonical role contains:

- the five phase order, the prior committed input rule, the approval gate, and one phase commit;
- the routing for phases 1, 2, 3, 4, and 5, including the uncovered component route;
- the coordination-only boundary and the phase content types that the coordinator cannot write;
- every Plan-Pn field and every handoff field from `spec-phase-messages`;
- the material-progress rule and the no-routine-message rule;
- the Phase 4 start fields, the absence of Plan-P4, and phase 3 approval as its gate; and
- the concise-message rule.

The evaluation must check that each selected harness renders the canonical role body. It must also check that the artifact-master skill identifies the role path for OpenCode, Claude, and Codex and does not copy the role body.

The evaluation may use text assertions for these instruction contracts. It must fail when a required instruction is absent or a rendered role differs from the canonical role contract.

## Errors

- A missing required role section fails the evaluation.
- A missing harness role or skill path fails the evaluation.
- A forbidden phase-content instruction for the artifact master fails the evaluation.
