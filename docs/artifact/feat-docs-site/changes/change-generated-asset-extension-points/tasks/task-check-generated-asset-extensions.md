# task-check-generated-asset-extensions: Check generated asset extensions

**Plan:** [Implementation plan](README.md)
**Covers:** req-generated-assets, spec-eval-checks
**Context:** context-factory

## Goal

Check the typed contract, rendered settings, workflow order, invalid values, and unchanged behavior.

## Steps

1. Extend the stub library with the type and rendering helpers that the module uses.
2. Add an extended module configuration that uses all extension points and step fields.
3. Check the option defaults and workflow step submodule declarations.
4. Check default and extended `site.json` values.
5. Check the added watch path and each custom step position.
6. Check all six rendered step fields.
7. Add invalid path and invalid step configurations.
8. Keep the existing notification, file, dependency, and disabled-state checks.
9. Run the Nix evaluation and Python notifier tests.
10. Run `git diff --check`.

## Check

All documented commands exit with status zero. The evaluation result exposes a true Boolean for
each new check.
