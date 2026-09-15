# spec-verification-contract: Verify the coordination contract

**Master:** [Specifications](README.md)
**Covers:** req-phase-control, req-expert-routing, req-content-ownership, req-commit-boundary, req-harness-delivery, req-phase-brief, req-user-direction, req-build-progress, req-phase-handoff, req-phase-four-communication, req-concise-communication, req-release-role, req-contract-driven-spec, req-interactive-recommend, req-parallel-implementation
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The artifact-driven composition evaluation must test the canonical source and rendered output. It
must use Boolean assertions. It must not claim to prove OpenCode runtime behavior.

The evaluation must check the canonical artifact-master role for these rules:

- It owns all expert spawning and coordination.
- It owns no phase content.
- It routes phases 1 through 5 to their content owners.
- It routes each phase 2 feasibility review without changing the contract.
- It selects an owner for an uncovered component with solution-expert advice.
- It makes phase 4 work batches from dependencies and each `can-parallel` answer.
- It starts the experts in each work batch and keeps one phase 4 commit.
- It keeps Plan-Pn approval, phase messages, and phase handoffs from the current contract.
- It states the OpenCode `allow`, explicit `deny`, and depth 1 declarations.

The evaluation must check the canonical solution-expert role for these rules:

- It owns phases 2 and 3 content and the phase 5 readiness gate.
- It writes each specification contract first.
- It calls no subagent and does not directly task another expert.
- It sends feasibility-review and owner-selection requests to the artifact master.
- It resolves returned constraints and writes the final decision.

Role-text and skill-text assertions must check the contract-first route and the no-subagent rule.
They must not assert that all decision records have resolved constraints.

The evaluation must inspect the rendered OpenCode config. It must assert these declared values:

| Rendered item | Required value |
| --- | --- |
| Artifact-master role frontmatter `mode` | `all` |
| Content-expert role frontmatter `mode` | `subagent` |
| Global settings `agent.artifact-master.permission.task` | `allow` |
| Global settings `agent.<content-expert>.permission.task` | `deny` |
| Global setting `subagent_depth` | `1` |

The declared-permission and deny-scope assertions apply only to roles that the factory renders.
Each deny must be explicit. A missing key does not satisfy the assertion. The test names and
reports these values as declared permissions, not runtime permissions.

The evaluation must compare the instruction body of each built-in role across OpenCode, Claude,
and Codex. It must exclude frontmatter and other harness declaration data from this comparison.
It must also check the artifact-master skill paths. The skill-text assertion must check the
instruction to select `artifact-master` as the primary OpenCode agent.

If `expert-role` leaves the solution-expert body, the evaluation must update or replace
`solutionExpertNamesSkill`. The assertion must agree with the role that owns uncovered-component
coordination.

The project-local experts are outside this evaluation contract. Their versioned behavior exists
only in these tracked instruction bodies:

- `utils/agent/role/factory-expert/ROLE.md`
- `utils/agent/role/nix-lib-expert/ROLE.md`

The two project-local descriptions in the ignored `devenv.local.nix` file are local-only. They
are outside the versioned contract and the versioned checks. The composition evaluation must not
inspect the tracked project-local bodies or the ignored descriptions. The factory does not render
these project-local roles.

The evaluation must check the canonical mixture-of-experts page and both layout mirrors. The
three page files must change together and have equal content. Each copy must explain spawning,
no-subagent behavior, feasibility routing, owner selection, phase 4 batching, primary-agent
selection, declared permissions, and depth 1.

### Events

| Event contract | Required check |
| --- | --- |
| Coordination moved | The role text names the artifact master as the only spawning owner. |
| Contract written | The solution expert sends a complete contract to the artifact master. |
| Feasibility routed | The artifact master sends the unchanged contract to the implementation expert. |
| Constraint returned | The constraint returns through the artifact master with its review identifier. |
| Owner selected | The artifact master records the selected owner and the solution-expert advice. |
| Work sequenced | The solution expert supplies approved scheduling data. |
| Work batched | The artifact master follows dependencies and each `can-parallel` answer. |
| Release routed | Readiness must be `true` before the release expert starts. |

### Data model

Each evaluation result must be a Boolean assertion. The complete evaluation must fail when one
required assertion is false.

The assertion groups must cover canonical role text, rendered instruction bodies, rendered
OpenCode config, skill text, wiki content, mirror equality, phase 4 batching, and phase 5 routing.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | A Repository blueprint is invalid when declared role permissions or rendered instruction bodies conflict with the coordination contract. |
| Upstream to downstream | None. `context-factory` is the only bounded context. Verification checks outputs in this context. |

## Description

The checks enforce the declared coordination boundary in source text, generated files, and
rendered OpenCode config. Nix evaluation does not prove harness runtime behavior.

## Constraint resolutions

The three decisions in this change record all feasibility constraints and their responsible
owners.

## Errors

- A missing canonical role rule, harness role, declared permission, or skill path fails the evaluation.
- An absent or non-deny task permission for a factory-rendered content expert fails the evaluation.
- An absent artifact-master task grant fails the evaluation.
- A subagent depth other than 1 fails the evaluation.
- A direct feasibility route from the solution expert fails the evaluation.
- A wiki mirror that differs from the canonical page fails the evaluation.
