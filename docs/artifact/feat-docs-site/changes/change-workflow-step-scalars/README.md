# Change: Accept workflow step scalars

**Feature:** [Documentation site](../../README.md)
**From:** 4.0.1
**To:** 4.0.2
**Type:** Correction

## Reason

GitHub Action inputs can use Boolean and numeric scalar values. The typed workflow step currently
accepts only strings in `with` and `env`. Thus, a common input such as
`latexmk_use_xelatex = true` stops Nix evaluation.

The two maps must accept strings, Booleans, integers, and floating-point numbers. The YAML renderer
already preserves these scalar types with `builtins.toJSON`.

## Artifacts

- [Corrected workflow-step specification](specifications/spec-docs-site-options.md)
- [Implementation plan](tasks/README.md)
