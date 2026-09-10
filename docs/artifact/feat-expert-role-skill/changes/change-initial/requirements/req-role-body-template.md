# req-role-body-template: Give the body template of an implementation expert role

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The expert role skill must give the body template of an implementation expert role. The
template must have these parts, in this order:

1. The intro. The expert owns phase 4 of the artifact-driven documentation model for its
   component. The expert gives the solution expert the specifications and the tasks of that
   component in phases 2 and 3. The expert does not write requirements.
2. The "Read first" list.
3. The domain description of the component.
4. The procedure for phases 2 and 3.
5. The procedure for phase 4.
6. The rules.
7. The output.

The skill must include one short filled example of the template for a fictional component.

## Acceptance criteria

- Given the expert role skill, when an agent reads the body template, then the template has the seven parts above, in the order above.
- Given the body template, when an agent reads the intro, then the intro says that the expert owns phase 4 for its component, gives the solution expert the specifications and the tasks of that component in phases 2 and 3, and does not write requirements.
- Given the expert role skill, when an agent reads it, then the skill has one filled example of the template for a fictional component.
- Given the filled example, when an agent reads it, then the example has each of the seven parts and is short enough to read on one screen.
- Given the body template, when an agent reads it, then the template has no status field and no phase tracking field.

## Notes

The body is the text of the role without the header that a harness adds. The skill must say this
so that the agent does not write a header in the body.
