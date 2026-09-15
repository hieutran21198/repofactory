# req-build-progress: Give useful build progress

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

During a phase build, the artifact master must report material progress at useful points. A
progress message must identify a completed result, a problem, a changed assumption, or a needed
user action.

## Acceptance criteria

- Given a phase build with material progress, when the artifact master reports it, then the message identifies the completed result.
- Given a problem or a changed assumption, when it affects the phase, then the artifact master reports its effect on the work.
- Given a build with no new material information, when the artifact master communicates, then it does not add a routine progress message.
- Given a phase build with more than one material result, when work continues, then the user receives progress before the phase handoff.

## Notes

A list of internal actions without a result is not material progress.
