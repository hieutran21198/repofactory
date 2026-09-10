# task-accept-scalar-map-values: Accept scalar map values

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-docs-site-options
**Context:** context-factory

## Goal

Let normal GitHub Actions scalar values pass the typed `with` and `env` contracts.

## Steps

1. Declare one local scalar union type.
2. Use the scalar type for `with` and `env` values.
3. Extend the test type stub with the four scalar members and `oneOf`.
4. Add Boolean and numeric values to the extended workflow fixture.
5. Check the rendered YAML scalar values.
6. Add the Boolean LaTeX input to the user guide example.
7. Run standalone and real module evaluations.

## Check

The real module evaluation accepts `latexmk_use_xelatex = true`. The generated workflow contains
the unquoted YAML value `true`.
