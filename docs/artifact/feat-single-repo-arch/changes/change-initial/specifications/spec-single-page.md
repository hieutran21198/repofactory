# spec-single-page: Define the architecture page and the directory seeds

**Master:** [Specifications](README.md)
**Covers:** req-single-layout

## Description

The architecture page `docs/wiki/repo-arch/single-repository.md` gives the layout, the rules,
and the growth path of the single repository architecture. The directory seeds give the purpose
of each directory in one short README.

## Contract

The architecture page has these sections, in this order:

1. Purpose. The repository is one component: one application, one service, or one library.
2. `## Directories`. A table with Directory and Content:

   | Directory | Content |
   | --- | --- |
   | `src/` | The implementation of the component. |
   | `tests/` | The tests that start the complete component. |
   | `deployment/` | The deployment configuration of the component. |
   | `docs/` | The project knowledge and the governance documents. |

3. `## Rules`.
   - Keep the code in `src/`.
   - Keep a unit test next to the code that it checks. Keep a test in `tests/` when it starts
     the complete component.
   - Keep the deployment configuration in `deployment/`.
   - Keep the knowledge that is not local to one file of code in `docs/`.
   - Do not add a second component to this repository.
4. `## Where to put new code`. A procedure: find the directory in the table, make a directory
   for the module in `src/` when the code is a new module, write a `README.md` in that directory.
5. `## When the project grows`. When the project needs a second component, change
   `repo-arch.use` to `multiple`. This repository becomes one component directory in `apps/`,
   `services/`, or `libs/`. Its `src/`, `tests/`, and `deployment/` move with it.

The page does not name a design method or a documentation model.

The directory seeds:

| Seed | Content |
| --- | --- |
| `README.md` | The repository is one component. The directory list. A link to the architecture page. |
| `AGENTS.md` | Read the architecture page. Keep the code in `src/`, the component tests in `tests/`, the deployment configuration in `deployment/`. |
| `docs/README.md` | The knowledge index with a link to the wiki. |
| `docs/wiki/README.md` | The wiki index with a link to the architecture page. |
| `src/README.md` | The implementation of the component. One directory for each module. |
| `tests/README.md` | The tests that start the complete component. Unit tests stay next to the code. |
| `deployment/README.md` | The deployment configuration. The target environment and the steps. |

## Errors

None. The page and the seeds are static files.
