# spec-release-role: Copy one feature version

**Master:** [Specifications](README.md)
**Covers:** req-release-role, req-expert-routing
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Contract

### Interface

The artifact master must send one phase 5 request to the artifact release expert. The solution
expert must confirm readiness before the artifact master sends the request.

The artifact release expert must do these operations only:

1. Copy the content of `versions/<from>/` to `versions/<to>/`.
2. Copy the change `requirements/`, `specifications/`, and `decisions/` over the new version.
3. Delete each path under `## Removed artifacts` in the change README.
4. Update the feature README as the phase 5 procedure requires.
5. Verify the copy before the phase commit.

For `change-initial`, the expert must omit the first operation. The expert must not edit a copied
artifact. It must not run a domain-driven design step. It must use a low-cost model or a script
with verification.

### Events

| Event | Producer | Consumer | Payload |
| --- | --- | --- | --- |
| Release routed | Artifact master | Artifact release expert | Phase, change path, source commit, and readiness confirmation. |
| Version copied | Artifact release expert | Artifact master | Version path, copied paths, deleted paths, and verification result. |

### Data model

The phase 5 request has this data model:

| Field | Type | Rule |
| --- | --- | --- |
| `change` | Repository path | It identifies one change README. |
| `from` | Version or `none` | It equals the `**From:**` value. |
| `to` | Version | It equals the `**To:**` value. |
| `source-commit` | Commit identifier | It contains the committed phase 4 output. |
| `readiness-confirmed` | Boolean | It must be `true`. |
| `removed-artifacts` | List of repository paths | It equals the paths in the change README. |

The verification result must identify each copied, replaced, and deleted path. It must confirm
that copied artifacts have the expected content before the phase commit.

### Domain rule

| Item | Value |
| --- | --- |
| Context | `context-factory` |
| Aggregate | `agg-repository-blueprint` |
| Invariant | Each generated artifact-driven repository routes phase 5 copy work to the artifact release expert. |
| Upstream to downstream | None. `context-factory` is the only bounded context. The actor route is artifact master to artifact release expert. |

## Constraints

| Constraint | Responsible owner |
| --- | --- |
| The Nix role builder must add the artifact release expert to its built-in role set. | `services/factory` implementation owner |
| The generic role renderer must render the new role for each selected harness. | `services/factory` implementation owner |
| The artifact-master role and skill must remove the old phase 5 route. | `services/factory` implementation owner |
| The canonical wiki page and its two layout mirrors must use the new route. | `services/factory` implementation owner |
| The phase 5 copy must follow the existing copy-and-delete procedure. | Artifact release expert |

These constraints are repository-evidence assumptions. `adr-release-routing` records the evidence
and the owner of each constraint.

## Errors

- If readiness is not confirmed, the artifact master must not route phase 5.
- If a copied artifact differs from its expected content, the expert must stop before the commit.
- If phase 5 needs an edit or a design change, the expert must stop and return the error.
