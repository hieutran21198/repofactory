# req-interactive-recommend: Interview the user with options and one recommendation

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The requirement expert in phase 1 and the solution expert in phase 2 must
draft a plan only. When an expert sees a correction or a better path, it must
interview the user with two or more options. Each option must give its
advantages and its disadvantages. The expert must give one recommendation. The
user selects the option. The expert finalizes the plan after the selection.
When only one feasible path exists, the expert must present it directly. The
artifact master must gate the build. It must not permit a final write before
the mid-build approval exists.

## Acceptance criteria

- Given a correction or a better path in phase 1 or phase 2, when the expert drafts the plan, then it interviews the user with two or more options with advantages, disadvantages, and one recommendation.
- Given the interview, when the user selects an option, then the expert finalizes the plan from the selection.
- Given one feasible path, when the expert drafts the plan, then it presents that path directly.
- Given a phase 1 or phase 2 build, when the expert writes final content, then the mid-build approval already exists.

## Notes

The mid-build approval is the user approval of the plan in the middle of the
phase build, before the expert writes final content.
