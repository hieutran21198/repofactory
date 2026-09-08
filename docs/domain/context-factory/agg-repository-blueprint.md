# agg-repository-blueprint: Repository blueprint

**Context:** context-factory
**Pattern:** Domain model

## Description

The repository blueprint combines selected domains and compositions into generated files. It owns
the rules that decide when the artifact issue integration exists.

## State transitions

| From | Command | To |
| --- | --- | --- |
| Options selected | Compose repository blueprint | Blueprint composed |

## Enforced invariants

- One repository blueprint selects at most one project-management provider.
- The artifact issue workflow needs the artifact-driven model and GitHub Actions.
- Each generated provider configuration contains its required location values.
- Each artifact type has one first status.

## Corrective policies

| Event | Policy |
| --- | --- |
| Artifact issue synchronization failed | Keep the repository artifacts unchanged and report the failure. |

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
