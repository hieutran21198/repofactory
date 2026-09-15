# task-templates: Add task scheduling fields

**Plan:** [Implementation plan](README.md)
**Covers:** req-parallel-implementation, spec-parallel-implementation
**Context:** context-factory
**Aggregate:** agg-repository-blueprint
**Component:** `services/factory`
**Dependency:** task-canonical-governance
**can-parallel:** no
**Parallel reason:** This task consumes the canonical phase 3 contract in the same context.

## Goal

Make each delivered phase 3 template record enough data to sequence phase 4 work.

## Steps

1. Add context, aggregate, component, dependency, and `can-parallel` fields to the task template.
2. Require one bounded context and one component in each task.
3. Require `none` or valid task identifiers in the dependency field.
4. Require `yes` or `no` in the `can-parallel` field.
5. Require a reason for the `can-parallel` answer.
6. Add ordered tasks, a dependency graph or table, and parallel groups to the plan template.
7. State that same-context or same-aggregate tasks run in sequence.
8. Put shared-kernel and published-language tasks before their consumers.
9. Put an upstream task before each downstream consumer.
10. State that phase 4 keeps all task output in one commit.
11. Update each factory-delivered copy of the two task templates.

## Verify

1. Check that each task template contains all required scheduling fields.
2. Check that the plan template contains the order, dependencies, and parallel groups.
3. Check that the templates prevent parallel work in one context or aggregate.
4. Check that the templates put library and upstream work before consumers.
5. Check that the canonical templates and all delivered copies agree.
