# req-select-provider: Select a provider during setup

**Master:** [Requirements](README.md)
**Context:** context-factory

## Need

The setup command must let a maintainer select GitHub Projects, Trello, or both providers.

## Acceptance criteria

- Given only GitHub credentials, when the maintainer selects GitHub Projects, then setup does not
  need Trello credentials.
- Given GitHub and Trello credentials, when the maintainer selects Trello, then setup creates no
  GitHub Project.
- Given no provider selection, when the maintainer runs setup, then setup selects both providers.
- Given state from one setup command, when the maintainer sets up the other provider, then the state
  keeps both provider resources.
