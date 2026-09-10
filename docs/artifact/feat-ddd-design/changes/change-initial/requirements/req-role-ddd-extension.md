# req-role-ddd-extension: Add the DDD steps to the roles

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

The requirement expert and the solution expert must do the DDD steps only when the project
selects DDD.

## Acceptance criteria

- Given a project that selects DDD, when the requirement expert does phase 1, then it names the subdomain and its type, the bounded context, the actors, the business events, and the glossary terms of the need.
- Given a project that selects DDD, when the solution expert does phase 2, then it writes the aggregates with their invariants, commands, and events, the contracts between the bounded contexts, and one decision that selects the implementation pattern.
- Given a project that selects DDD, when the solution expert does phase 3, then each task belongs to one bounded context.
- Given a project that does not select DDD, when the factory generates the roles, then the roles are the same as before this feature.
- Given a project that selects DDD, when the factory generates the roles, then each harness in use gets the DDD steps.

## Notes

The requirement expert owns the strategic design because it talks to the business. The solution
expert owns the tactical design because it decides how the requirements are met.
