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
| Wire surface changed | Run contract gates | Gates passed |
| Gates passed | Publish provider contract | Contract published |
| Contract published | Compare provider contract | Comparison reported |

## Enforced invariants

- One repository blueprint selects at most one project-management provider.
- An enabled artifact issue composition needs the artifact-driven model and one selected CI provider (github-actions or azure-pipelines).
- An enabled artifact issue composition needs one supported project-management adapter.
- The Azure Pipelines folder defaults to `azure-pipelines`.
- The Azure Pipelines folder is a non-empty relative POSIX repository path.
- The Azure Pipelines folder does not start with `/`.
- Each Azure Pipelines folder segment is non-empty and is not `.` or `..`.
- The Azure Pipelines folder does not contain a backslash.
- An enabled artifact issue composition emits the Azure pipeline at `<folder>/accepted-artifact-issues.yml` when it selects Azure Pipelines.
- An Azure Pipelines folder change changes only the pipeline path. It does not change the pipeline content.
- The Azure Pipelines folder does not change a GitHub Actions path or file.
- Each selected adapter owns its target and credential settings.
- The artifact issue composition gives each artifact type one first status.
- An enabled acceptance notification selects one or more supported notification providers and their settings.
- An enabled documentation site composition needs the artifact-driven model, the multiple
  repositories architecture, and one selected CI provider (github-actions or azure-pipelines).
- An enabled documentation site composition has a title, a site URL, and a base URL.
- An enabled documentation site composition selects exactly one publication target.
- The publication target is `github-pages` or `azure-static-web-app`.
- The publication target is `github-pages` unless the maintainer selects `azure-static-web-app`.
- A documentation site with the `azure-static-web-app` target selects exactly one deploy tool: `official-task` or `swa-cli`.
- A documentation site with the `azure-static-web-app` target names the secret that holds the Static Web App deployment token.
- A documentation site extension adds typed static directories, watch paths, and build steps without replacing a factory-owned file.
- An enabled deployment notification selects one or more supported notification providers and their settings.
- An artifact-driven repository has one canonical artifact-master role body.
- Each selected harness receives a rendered artifact-master role with the canonical coordination and message contract.
- The artifact-master skill identifies the rendered role of each supported harness and does not repeat the canonical role body.
- An artifact-driven repository receives one self-contained mixture-of-experts wiki page for its selected repository architecture.
- Each provider component with a wire surface owns one machine-readable contract for its wire surface.
- The contract describes each operation that a consumer team can use.
- The contract uses the language that the selection rule gives for its wire surface.
- A provider change passes contract lint, runtime verification, and breaking-change comparison before consumers accept it.
- Each release publishes the contract that matches the release.

## Corrective policies

| Event | Policy |
| --- | --- |
| Artifact issue synchronization failed | Keep the repository artifacts unchanged and report the failure. |
| Accepted artifacts synchronized | Send one acceptance notification when notification is enabled. |
| Acceptance notification failed | Retry delivery and report the final failure. |
| Documentation site deployed | Send one deployment notification when notification is enabled. |
| Deployment notification failed | Retry delivery and report the last failure. |
| Breaking change detected | Block consumer acceptance and inform each consumer team. |
| Contract gate failed | Keep the prior published contract and report the failure to the provider team. |

## Handled commands

| Command | Result | Emits |
| --- | --- | --- |
| Compose repository blueprint | Generate the selected files or return an option error. | Repository blueprint composed |
| Run contract gates | Run lint, verification, and breaking-change comparison, or return a gate error. | Contract gate failed |
| Publish provider contract | Publish the contract with the release, or return a publication error. | Provider contract published |
| Compare provider contract | Compare two release contracts and report compatible or breaking. | Breaking change detected |

## Created events

| Event | Payload |
| --- | --- |
| Repository blueprint composed | Selected domains, compositions, generated file paths, and rendered artifact-master role paths. |
| Provider contract published | Provider identity, release tag, wire surface, contract language, and contract asset path. |
| Breaking change detected | Provider identity, old and new release tags, and each added, altered, and removed operation. |
| Contract gate failed | Gate name, operation identifiers, and the failure cause. |

## References by identity

| Aggregate | Context |
| --- | --- |

## Notes

Provider adapters synchronize external issues after the generated repository exists.
