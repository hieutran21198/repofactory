# task-verify-generation: Verify the generated files

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-option, req-domain-model-artifacts, req-role-ddd-extension

## Goal

The generated repository has the DDD files and the extended roles when the option is set, and
has none of them when the option is not set.

## Steps

1. Set `design.use = "ddd"` in `devenv.local.nix` and enter the shell.
2. List `docs/domain/` and `docs/wiki/design/ddd/`.
3. Search the agent files of each harness for the heading `Domain-Driven Design`.
4. Remove the option, enter the shell, and search again.
5. Run `git diff --check`.

## Check

Step 2 shows the seeds and the copies. Step 3 finds the heading in each agent file of each
harness. Step 4 finds no heading. Step 5 reports no error.
