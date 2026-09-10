# Specifications: Single repository architecture

## Solution

The module `services/factory/domain/repo-arch/single/default.nix` seeds the root layout and the
architecture page. The artifact-driven composition selects a single-repository variant of the
agent guidance and the wiki index, with and without DDD. The DDD module and the composition keep
one asset tree for each repository architecture. The multiple repositories module does not change.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-single-seed](spec-single-seed.md) | Define the file map of the single repository module. | req-single-layout |
| [spec-single-page](spec-single-page.md) | Define the content of the architecture page and the directory seeds. | req-single-layout |
| [spec-single-composition](spec-single-composition.md) | Define the guidance variants of the artifact-driven composition. | req-single-guidance |
| [spec-single-context-home](spec-single-context-home.md) | Define the bounded context rule for the single repository architecture. | req-single-context-rule |
| [spec-ddd-arch-trees](spec-ddd-arch-trees.md) | Define the asset trees and the file map of the DDD module. | req-single-context-rule |
| [spec-composition-arch-trees](spec-composition-arch-trees.md) | Define the asset trees, the role chapter path, and the phase-mapping page of the composition. | req-single-guidance, req-single-context-rule |

## Decisions

- [adr-single-layout](../decisions/adr-single-layout.md)
- [adr-single-context-home](../decisions/adr-single-context-home.md)
- [adr-ddd-selection-in-domain](../decisions/adr-ddd-selection-in-domain.md)
