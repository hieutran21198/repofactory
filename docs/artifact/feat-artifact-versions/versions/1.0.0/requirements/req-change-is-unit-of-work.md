# req-change-is-unit-of-work: A change is the unit of work

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

Each unit of work on a feature must be a change in `docs/artifact/feat-<name>/changes/change-<name>/`.
The first build of a feature is also a change. Its name must be `change-initial`. Phases 1 to 4
(requirements, specifications, plan, and implementation) must happen inside the change folder.
Tasks must exist only inside a change.

## Acceptance criteria

- Given a new feature, when the requirement expert starts phase 1, then the requirements are in `changes/change-initial/requirements/` and not in a root `requirements/` folder.
- Given a change, when the solution expert does phases 2 and 3, then the specifications, the decisions, and the tasks are inside the change folder.
- Given a feature, when a reader looks for a task, then each task is inside a `changes/change-<name>/tasks/` folder.
- Given a feature, when a reader lists its root folders, then the feature has no root `requirements/`, `specifications/`, `decisions/`, or `tasks/` folder.

## Notes

The old model kept the first build in root folders and used a change folder only after the code
existed. The new model has one shape for all work on a feature.
