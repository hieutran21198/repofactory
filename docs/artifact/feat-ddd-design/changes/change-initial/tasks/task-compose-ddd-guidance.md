# task-compose-ddd-guidance: Add the DDD guidance variants and the phase-mapping page

**Plan:** [Implementation plan](README.md)
**Covers:** req-ddd-guidance, spec-artifact-references, spec-composition-guidance

## Goal

The composition selects the DDD variants of the guidance files and emits the phase-mapping page
when `design.use` is `ddd`.

## Steps

1. Write `_assets/ddd/AGENTS.md`, `_assets/ddd/docs/README.md`, and
   `_assets/ddd/docs/wiki/README.md` with the additions of `spec-composition-guidance`.
2. Write `_assets/ddd/docs/wiki/design/ddd/artifact-driven.md` with the phase table and the
   reference table of `spec-artifact-references`.
3. Select the source of the three guidance files with `if ddd` in the composition module.
4. Add the block that emits the phase-mapping page.
5. Review the text with the `asd-ste-100` skill.

## Check

Evaluate the composition with `design.use` set to `ddd` and to `unset`. The sources and the
phase-mapping page follow `spec-composition-guidance` in both cases.
