# Implementation plan: Artifact master

**Change:** [Mixture of experts wiki](../../../changes/change-mixture-of-experts-wiki/README.md)

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-moex-page](task-moex-page.md) | - |
| 2 | [task-moex-delivery](task-moex-delivery.md) | 1 |

Both tasks are in `context-factory`. The page task supplies the content and its index links.
The delivery task wires and checks that content.

## Artifact coverage

| Requirement | Specification | Tasks |
| --- | --- | --- |
| req-moex-explanation | spec-moex-page | task-moex-page |
| req-moex-nix-delivery | spec-moex-delivery | task-moex-page, task-moex-delivery |

## Definition of done

- The canonical page and both repository-layout mirrors have the same content.
- All five wiki indexes link to the page.
- All four layout and DDD combinations receive the page as a copied file.
- The artifact-driven composition evaluation passes.
- The acceptance criteria of both requirements pass.
