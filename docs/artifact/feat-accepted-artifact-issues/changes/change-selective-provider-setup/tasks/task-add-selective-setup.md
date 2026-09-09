# task-add-selective-setup: Add selective setup

**Master:** [Implementation plan](README.md)
**Covers:** req-select-provider, spec-selective-setup
**Context:** context-factory

## Work

1. Add the provider option to the setup command.
2. Check only the credentials that the selection needs.
3. Create and deploy only the selected provider resources.
4. Merge new provider resources into the current state.
5. Add unit checks for selective setup and partial state.
6. Update the component instructions and master specification.

## Done when

- The setup command can set up GitHub Projects without Trello credentials.
- A later setup command can add Trello resources to the same state file.
- The existing provider checks continue to pass.
