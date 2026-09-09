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
- An enabled artifact issue composition needs the artifact-driven model and GitHub Actions.
- An enabled artifact issue composition needs one supported project-management adapter.
- Each selected adapter owns its target and credential settings.
- The artifact issue composition gives each artifact type one first status.
- An enabled acceptance notification selects Google Chat or Slack and one webhook secret name.
- An enabled documentation site composition needs the artifact-driven model, the multiple
  repositories architecture, and GitHub Actions.
- An enabled documentation site composition has a title, a site URL, and a base URL.

## Corrective policies

| Event | Policy |
| --- | --- |
| Artifact issue synchronization failed | Keep the repository artifacts unchanged and report the failure. |
| Accepted artifacts synchronized | Send one acceptance notification when notification is enabled. |
| Acceptance notification failed | Retry delivery and report the final failure. |

## Handled commands

| Command | Result | Emits |
| --- | --- | --- |
| Compose repository blueprint | Generate the selected files or return an option error. | Repository blueprint composed |

## Created events

| Event | Payload |
| --- | --- |
| Repository blueprint composed | Selected domains, compositions, and generated file paths. |

## References by identity

| Aggregate | Context |
| --- | --- |

## Notes

Provider adapters synchronize external issues after the generated repository exists.
