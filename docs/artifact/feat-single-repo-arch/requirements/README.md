# Requirements: Single repository architecture

## Business need

Project teams with one deliverable need a repository layout that agents can follow without the
component-type split of the multiple repositories architecture. The option `repo-arch.use`
accepts the value `single`, but the generator writes no file for it. The generated project must
give one location for the code, one for the tests of the complete component, one for the
deployment configuration, and one for the project knowledge.

## Scope

- In scope: The seeded files of the single repository architecture, its architecture page, the
  generated agent guidance, and the rule that maps a bounded context to this architecture.
- Out of scope: A language toolchain, a test framework, a build system, or a CI configuration.

## Teardown requirements

| ID | Requirement | Priority |
| --- | --- | --- |
| [req-single-layout](req-single-layout.md) | The generator must seed the root layout of the single repository architecture. | Must |
| [req-single-guidance](req-single-guidance.md) | The generated guidance must point at the single repository architecture page. | Must |
| [req-single-context-rule](req-single-context-rule.md) | The design guide must give the home of a bounded context in the single repository architecture. | Must |

## Acceptance

A project with `repo-arch.use = "single"` gets the seeded layout, the architecture page, and
guidance that names that page. A project with `repo-arch.use = "multiple"` gets no file of the
single repository architecture.
