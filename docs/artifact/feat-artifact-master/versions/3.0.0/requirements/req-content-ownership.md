# req-content-ownership: Keep the coordination boundary

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact master must own coordination only. It must not write or decide the content that the
owner of a phase must write or decide.

## Acceptance criteria

- Given a phase build, when the artifact master coordinates it, then the owner of the phase writes the phase content.
- Given a content decision, when the phase owner finds it, then the artifact master does not select the result.
- Given a user choice about content, when the artifact master reports it, then it identifies the expert that needs the answer.

## Notes

The artifact master can check that the committed output agrees with the approved phase plan.
