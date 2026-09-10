# task-extend-roles: Append the DDD chapter to the roles

**Plan:** [Implementation plan](README.md)
**Covers:** req-role-ddd-extension, spec-role-extension

## Goal

The requirement expert and the solution expert get the DDD chapter when `design.use` is `ddd`.

## Steps

1. Write `_assets/ddd/agent/role/requirement-expert/ROLE.md` with the phase 1 steps and rules of
   `spec-role-extension`.
2. Write `_assets/ddd/agent/role/solution-expert/ROLE.md` with the phase 2 and phase 3 steps and
   rules of `spec-role-extension`.
3. Read `design` in the composition module and compute `ddd`.
4. Change `mkRole` so that it appends the chapter as `spec-role-extension` defines.
5. Review the text with the `asd-ste-100` skill.

## Check

Evaluate the composition with `design.use` set to `ddd`. Each role instruction is the base file,
one newline, and the chapter. With `design.use` set to `unset`, each role instruction is the
base file.
