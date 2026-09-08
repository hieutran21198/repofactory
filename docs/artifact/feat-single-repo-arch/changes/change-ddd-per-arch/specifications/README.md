# Specifications: DDD assets per architecture

## Solution

The DDD module keeps one asset tree for each repository architecture and one shared tree for
the architecture-neutral seeds. It reads `repo-arch.use` and emits the design guide and the
templates of the active architecture only. The artifact-driven composition keeps one asset tree
for each architecture as well, with the guidance, the DDD role chapters, and the phase-mapping
page of that architecture. When the architecture is not set, the DDD module emits the neutral
seeds only, and the composition emits no DDD chapter and no phase-mapping page.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-ddd-arch-trees](spec-ddd-arch-trees.md) | Define the asset trees and the file map of the DDD module. | req-single-context-rule |
| [spec-composition-arch-trees](spec-composition-arch-trees.md) | Define the asset trees, the role chapter path, and the phase-mapping page of the composition. | req-single-guidance, req-single-context-rule |

## Decisions

- [adr-ddd-selection-in-domain](../decisions/adr-ddd-selection-in-domain.md)
