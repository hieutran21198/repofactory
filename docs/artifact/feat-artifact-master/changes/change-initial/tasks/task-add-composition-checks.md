# task-add-composition-checks: Add composition checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, spec-verification-contract
**Context:** context-factory

## Goal

Add composition evaluation checks for the artifact-master role and skill contract.

## Files

- `services/factory/composition/artifact-driven/tests/eval.nix`

## Steps

1. Check the canonical role for the phase-control, routing, and coordination rules.
2. Check the role for all plan, progress, Phase 4, handoff, and concise-message rules.
3. Check that each selected harness renders the canonical role body.
4. Check the artifact-master skill paths for OpenCode, Claude, and Codex.
5. Check that the skill does not copy the canonical role body.
6. Keep failures for a missing role, missing path, or changed role contract.

## Check

Run the artifact-driven composition evaluation. Check selected and unselected harness configurations.
