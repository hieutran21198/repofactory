# req-roles-follow-model: Each role and each guidance file follows the model

**Master:** [Requirements](README.md)
**Context:** context-factory
**Priority:** Must

## Statement

The requirement expert must own phase 1 and must write the change README of each change, of each
type. The solution expert must own phases 2, 3, and 5. An implementation expert must read the
tasks of the change and the current version of the feature for context. The wiki page of the
model, the templates, the role bodies, the expert-role skill, the DDD phase table, the AGENTS.md
guidance, and the ddd-review skill must describe the same model. The factory seeds each of these
files.

## Acceptance criteria

- Given a change of any type, when the change starts, then the requirement expert writes the change README with From, To, Type, and the reason.
- Given a change whose code exists, when phase 5 starts, then the solution expert produces the version.
- Given a task in a change, when an implementation expert does the task, then the expert reads the task and the current version of the feature for context.
- Given a generated project with artifact-driven documentation, when a reader compares the wiki page, the templates, the role bodies, the expert-role skill, the DDD phase table, the AGENTS.md guidance, and the ddd-review skill, then each describes the change folder, the version folder, the five phases, and the same phase owners.
- Given a generated project with artifact-driven documentation, when a reader looks for the old model in a seeded file, then no seeded file tells the author to update root artifacts after a change.

## Notes

The factory seeds all of these files. One source of the model in the factory makes them agree.
