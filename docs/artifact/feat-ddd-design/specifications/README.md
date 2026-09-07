# Specifications: DDD design

## Solution

The factory gets a new domain `design` with the option `design.use`. The value `ddd` turns on a
module that emits the design guide, the domain templates, and the seeds of `docs/domain/`.

The artifact-driven composition reads the same option. When the value is `ddd`, it appends a DDD
chapter to the instruction of the requirement expert and the solution expert, selects the DDD
variant of the agent guidance and the knowledge indexes, and emits one page that maps the DDD
steps to the five phases. When the value is not `ddd`, the composition emits the same files as
before this feature.

The components that change are the factory domain modules and the artifact-driven composition.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-design-option](spec-design-option.md) | Define the `design.use` option. | req-design-option |
| [spec-ddd-files](spec-ddd-files.md) | Define the files that the DDD module emits and their copy modes. | req-ddd-guidance, req-domain-model-artifacts |
| [spec-domain-templates](spec-domain-templates.md) | Define the shape of each domain artifact. | req-domain-model-artifacts, req-context-boundary-rule |
| [spec-role-extension](spec-role-extension.md) | Define how the composition appends the DDD chapter to a role. | req-role-ddd-extension |
| [spec-artifact-references](spec-artifact-references.md) | Define how a feature artifact points to a domain artifact. | req-domain-model-artifacts |
| [spec-composition-guidance](spec-composition-guidance.md) | Define the DDD variants of the guidance files and the phase-mapping page. | req-ddd-guidance, req-context-boundary-rule |

## Decisions

- [adr-role-extension-mechanism](../decisions/adr-role-extension-mechanism.md)
- [adr-domain-templates-location](../decisions/adr-domain-templates-location.md)
- [adr-ddd-phase-mapping-page](../decisions/adr-ddd-phase-mapping-page.md)
- [adr-context-boundary](../decisions/adr-context-boundary.md)
