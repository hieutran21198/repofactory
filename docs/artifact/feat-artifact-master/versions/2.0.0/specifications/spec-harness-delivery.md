# spec-harness-delivery: Deliver the role to each harness

**Master:** [Specifications](README.md)
**Covers:** req-harness-delivery
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The repository factory renders the canonical artifact-master role for each harness that the repository blueprint selects. It supplies the artifact-master skill with the same blueprint.

## Contract

The canonical role body is the source of phase control and phase messages. The factory renders that body into the artifact-master role for OpenCode, Claude, and Codex when the harness is in use. The rendered role can add harness-specific declaration data only. It must not change the role body contract.

The artifact-master skill must not repeat the role body. It must identify the rendered role path for the harness in use and instruct the harness to load that role before it coordinates a change. The skill must preserve the role routing, phase order, approval gates, and phase 4 rule.

OpenCode supplies artifact-master as a selectable coordinator role. Claude and Codex supply it as a delegated role and supply the delegating skill.

## Errors

- If a selected harness has no rendered artifact-master role, fail the blueprint evaluation.
- If the skill has no path for a selected harness, fail the blueprint evaluation.
- If a rendered role changes the canonical message contract, fail the blueprint evaluation.
