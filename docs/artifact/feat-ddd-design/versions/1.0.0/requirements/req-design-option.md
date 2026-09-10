# req-design-option: Select DDD with one factory option

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

A project must select domain-driven design as its design method with one factory option.

## Acceptance criteria

- Given a project configuration, when the user sets the design option to DDD, then the factory generates the DDD files.
- Given a project configuration, when the user does not set the design option, then the factory generates no DDD file.
- Given a project configuration, when the user sets the design option to a value that the factory does not know, then the evaluation fails with an error.

## Notes

The factory has the same shape of option for the documentation model and for the repository
architecture. The design option must follow the same shape.
