# spec-provider-credential-guide: Generate provider credential procedures

**Master:** [Specifications](README.md)
**Covers:** req-provider-adapters
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

The artifact-driven project-issues composition emits a credential guide with its other setup
files. The guide covers GitHub Projects and Trello, independent of the selected provider. The main
project-issues guide links to this procedure.

## GitHub contract

The guide distinguishes these names:

- `GITHUB_TOKEN` is the automatic GitHub Actions token for repository issues and comments.
- `GH_TOKEN` is a temporary local variable for GitHub CLI commands.
- `PROJECTS_TOKEN` is the default repository secret for GitHub Projects access.

The guide tells the user to make a classic personal access token with `repo` and `project` scopes.
It explains that `workflow` is necessary only when the token changes workflow files. It also
explains the personal-project restriction of fine-grained personal access tokens.

The procedure uses a silent shell prompt. It sends the value to `gh secret set` through standard
input. It does not put the token value in command arguments.

## Trello contract

The guide tells the user to make a Power-Up API key and authorize a user token with `read` and
`write` scopes. The user selects `1day`, `30days`, or `never` expiration. The guide recommends a
dedicated automation account for a token that does not expire.

The procedure uses silent prompts for `TRELLO_API_KEY` and `TRELLO_TOKEN`. It sends each value to
the repository secret with the same default name.

## Security and checks

The guide tells the user not to commit, display, or pass token values as command arguments. It
removes local variables after use. It gives commands to check secret names and run the generated
workflow manually. It also gives rotation and revocation instructions.

The generated credential guide exists only when project issues are enabled.
