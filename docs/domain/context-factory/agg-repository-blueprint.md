# agg-repository-blueprint: Repository blueprint

**Context:** context-factory
**Pattern:** Domain model

## Description

The repository blueprint combines selected domains and compositions into generated files. Each
composition owns its activation and cross-domain policies. A provider selection identifies an
adapter but does not activate a composition.

## State transitions

| From | Command | To |
| --- | --- | --- |
| Options selected | Compose repository blueprint | Blueprint composed |

## Enforced invariants

- One repository blueprint selects at most one project-management provider.
- An enabled artifact issue composition needs the artifact-driven model and one selected CI provider (github-actions or azure-pipelines).
- An enabled artifact issue composition needs one supported project-management adapter.
- Each selected adapter owns its target and credential settings.
- The artifact issue composition gives each artifact type one first status.
- An enabled acceptance notification selects one or more supported notification providers and their settings.
- An enabled documentation site composition needs the artifact-driven model, the multiple
  repositories architecture, and one selected CI provider (github-actions or azure-pipelines).
- An enabled documentation site composition has a title, a site URL, and a base URL.
- An enabled documentation site composition selects exactly one publication target.
- The publication target is `github-pages` or `azure-static-web-app`.
- The publication target is `github-pages` unless the maintainer selects `azure-static-web-app`.
- A documentation site with the `azure-static-web-app` target names the secret that holds the Static Web App deployment token.
- A documentation site extension adds typed static directories, watch paths, and build steps without replacing a factory-owned file.
- An enabled deployment notification selects one or more supported notification providers and their settings.
- An artifact-driven repository has one canonical artifact-master role body.
- Each selected harness receives a rendered artifact-master role with the canonical coordination and message contract.
- The artifact-master skill identifies the rendered role of each supported harness and does not repeat the canonical role body.

## Corrective policies

| Event | Policy |
| --- | --- |
| Artifact issue synchronization failed | Keep the repository artifacts unchanged and report the failure. |
| Accepted artifacts synchronized | Send one acceptance notification when notification is enabled. |
| Acceptance notification failed | Retry delivery and report the final failure. |
| Documentation site deployed | Send one deployment notification when notification is enabled. |
| Deployment notification failed | Retry delivery and report the last failure. |

## Handled commands

| Command | Result | Emits |
| --- | --- | --- |
| Compose repository blueprint | Generate the selected files or return an option error. | Repository blueprint composed |

## Created events

| Event | Payload |
| --- | --- |
| Repository blueprint composed | Selected domains, compositions, generated file paths, and rendered artifact-master role paths. |

## References by identity

| Aggregate | Context |
| --- | --- |

## Notes

Provider adapters synchronize external issues after the generated repository exists.
