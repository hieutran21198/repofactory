# Single Repository Architecture

This repository is one component. A component is one application, one service, or one library.
The repository holds the code of the component, the tests that start it, its deployment
configuration, and the project knowledge. The layout is the same for every language.

## Directories

| Directory | Content |
| --- | --- |
| `src/` | The implementation of the component. |
| `tests/` | The tests that start the complete component. |
| `deployment/` | The deployment configuration of the component. |
| `docs/` | The project knowledge and the governance documents. |

## Rules

- Keep the code in `src/`.
- Keep a unit test next to the code that it checks. Keep a test in `tests/` when it starts the
  complete component.
- Keep the deployment configuration in `deployment/`.
- Keep the knowledge that is not local to one file of code in `docs/`.
- Do not add a second component to this repository.

## Where to put new code

1. Find the directory in the table above.
2. If the code is a new module, make a new directory for the module in `src/`.
3. Write a `README.md` in the new directory. Give the purpose of the module.

## When the project grows

When the project needs a second component, change `repo-arch.use` to `multiple`. This
repository becomes one component directory in `apps/`, `services/`, or `libs/` of the multiple
repositories architecture. Its `src/`, `tests/`, and `deployment/` directories move with it.
