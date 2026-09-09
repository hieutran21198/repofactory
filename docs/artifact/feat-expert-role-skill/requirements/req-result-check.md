# req-result-check: Tell the agent how to check the result

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The expert role skill must tell the agent how to check the result. The check has two steps:
enter the shell again, then inspect the rendered role file of each harness in use.

## Acceptance criteria

- Given the expert role skill, when an agent reads the check, then the check tells the agent to enter the shell again after it writes the role body and the role declaration.
- Given the expert role skill, when an agent reads the check, then the check gives the location of the rendered role file for each harness in use.
- Given a rendered role file, when an agent reads the check, then the check says what the agent must find in the file: the header that the harness adds and the body of the role.
- Given a harness that the project does not use, when an agent reads the check, then the check tells the agent that this harness has no rendered role file.

## Notes

A rendered role file is not a source. The check tells the agent to change the body or the
declaration and to render again, not to edit the rendered file.
