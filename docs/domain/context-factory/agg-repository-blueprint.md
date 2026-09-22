# agg-repository-blueprint: Repository blueprint

**Context:** context-factory
**Pattern:** Domain model

## Description

The repository blueprint combines selected domains and compositions into generated files. Each
composition owns its activation. Each harness module owns the settings that it renders. A
provider selection identifies an adapter but does not activate a composition. The Pencil adapter
uses a local pen.dev host and the open `.pen` document.

## State transitions

| From | Command | To |
| --- | --- | --- |
| Options selected | Compose repository blueprint | Blueprint composed with the selected design tool and UX Design when enabled |
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
- For the project-issues composition, an Azure Pipelines folder change changes only the pipeline path.
- An enabled documentation site composition emits the Azure pipeline at `<folder>/docs-site.yml` when it selects Azure Pipelines.
- For the docs-site composition, an Azure Pipelines folder change changes only the pipeline path and its trigger self-path.
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
- An enabled documentation site feature order contains unique, non-empty feature folder basenames.
- A generated documentation site receives the selected feature order through `site.json`.
- An enabled deployment notification selects one or more supported notification providers and their settings.
- An artifact-driven repository has one canonical artifact-master role body.
- Each selected harness receives a rendered artifact-master role with the canonical coordination and message contract.
- The artifact-master skill identifies the rendered role of each supported harness and does not repeat the canonical role body.
- An artifact-driven repository has one canonical artifact-release-expert role body.
- Each selected harness receives a rendered artifact-release-expert role with the copy-only phase 5 contract.
- The artifact master routes phase 5 to the artifact release expert after the solution expert confirms readiness.
- The solution expert owns each specification and final decision. An implementation expert returns feasibility constraints only.
- A phase 1 or phase 2 expert gets user approval before a final write when it finds a correction or better path.
- Each phase 3 task records its dependencies and one `can-parallel` answer.
- Phase 4 obeys task dependencies, runs permitted tasks in parallel, and keeps one commit.
- An artifact-driven repository receives one self-contained mixture-of-experts wiki page for its selected repository architecture.
- Each provider component with a wire surface owns one machine-readable contract for its wire surface.
- The contract describes each operation that a consumer team can use.
- The contract uses the language that the selection rule gives for its wire surface.
- A provider change passes contract lint, runtime verification, and breaking-change comparison before consumers accept it.
- Each release publishes the contract that matches the release.
- The UX Design enable value defaults to `false`.
- The UX Design enable option declaration renders no file.
- When UX Design is off, each generated file is byte-identical to the file before UX Design.
- When UX Design is off, the repository blueprint adds no designer role, role chapter, Design template, or design tool configuration.
- UX Design does not change an always-copied guidance, artifact-model, or mixture-of-experts file.
- When UX Design is on, the repository blueprint adds UX Design only to phase 2 and keeps five phases.
- An enabled UX Design composition uses an enable-gated merge for each generated addition.
- An enabled UX Design composition renders the designer expert as a content role for each selected harness.
- The OpenCode designer expert uses subagent mode and has declared task permission `deny`.
- An optional UX Design role chapter follows the optional Domain-Driven Design chapter and does not change a base role body.
- The enabled composition emits the Design template outside the always-copied template source.
- The enabled release role chapter copies `design/` in phase 5 without a new phase or option.
- The design-tool `use` value is `unset`, `figma`, or `pencil`, and its default is `unset`.
- The design-tool domain declares only `use` and emits no MCP setting.
- The `use` value alone emits no MCP setting.
- The artifact-driven composition sets the internal harness UX Design signal to its enable value.
- A harness module does not read an option in the composition namespace.
- Each selected Claude, OpenCode, or Codex harness module owns its MCP setting and output.
- A harness module adds `figma-ui-mcp` only when UX Design is on and `use` is `figma`.
- A harness module adds `pencil` only when UX Design is on and `use` is `pencil`.
- The Pencil MCP entry key is `pencil` in each harness.
- The Pencil MCP transport is stdio, and its portable command is `pencil`.
- Claude uses `type = "stdio"`, `command = "pencil"`, empty `args`, and empty `env`.
- OpenCode uses `type = "local"`, `command = ["pencil"]`, and `enabled = true`.
- Codex uses `command = "pencil"` and empty `args`.
- The Pencil adapter uses only the local pen.dev host and the open `.pen` document.
- The Pencil MCP entry has no machine-specific path or document path.
- The Pencil adapter grants no remote endpoint or filesystem privilege.
- A Pencil selection does not add `figma-ui-mcp`, and a Figma selection does not add `pencil`.
- A harness module preserves each unrelated harness setting and each MCP entry with a different name.
- An active harness module rejects a final `figma-ui-mcp` value that differs from its canonical value.
- An active harness module rejects a final `pencil` value that differs from its canonical local value.
- The `use` value does not enable UX Design and does not gate the Design artifact.
- An unavailable design tool or a failed tool operation does not block the Design artifact.
- A completed Design artifact has UX, Layout, Interaction, Components, and Design System sections.
- The designer expert reuses a fitting component or token before it defines a new item.
- The Design artifact does not override a Requirement, Spec, or ADR.

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
| Requirements accepted | Send Start Design work with the selected `use` value in phase 2 when UX Design is enabled. |
| Specifications and decisions written | Send Reconcile Design before the phase 2 join. |

## Handled commands

| Command | Result | Emits |
| --- | --- | --- |
| Compose repository blueprint | Validate the design-tool selection and generate the selected files, or return an option error. | Repository blueprint composed; Design tool selected; UX Design enabled when selected |
| Run contract gates | Run lint, verification, and breaking-change comparison, or return a gate error. | Contract gate failed |
| Publish provider contract | Publish the contract with the release, or return a publication error. | Provider contract published |
| Compare provider contract | Compare two release contracts and report compatible or breaking. | Breaking change detected |

## Created events

| Event | Payload |
| --- | --- |
| Repository blueprint composed | Selected domains, compositions, generated file paths, and rendered built-in role paths. |
| Design tool selected | Selected `use` value, selected harnesses, transport, canonical entry fields, and active MCP paths. |
| Provider contract published | Provider identity, release tag, wire surface, contract language, and contract asset path. |
| Breaking change detected | Provider identity, old and new release tags, and each added, altered, and removed operation. |
| Contract gate failed | Gate name, operation identifiers, and the failure cause. |
| UX Design enabled | Enable value, `use` value, designer role paths, Design template paths, and harness configuration paths. |

These events document domain results. `services/factory` has no runtime event mechanism for the
design-tool selection.

## References by identity

| Aggregate | Context |
| --- | --- |

## Notes

Provider adapters synchronize external issues after the generated repository exists.
