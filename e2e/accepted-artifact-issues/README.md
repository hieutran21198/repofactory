# Accepted Artifact Issues End-to-End Check

This component checks the generated GitHub Projects and Trello integrations. It uses two private
GitHub repositories and separate provider resources.

The commands change live GitHub and Trello data. Use only the specified test resources.

## Prerequisites

1. Make a classic GitHub personal access token.
2. Give the token the `repo`, `project`, and `workflow` scopes.
3. Set `GH_TOKEN` to the token value.
4. To use Trello, make a Trello API key and a Trello user token.
5. To use Trello, set `TRELLO_API_KEY` and `TRELLO_TOKEN` to the Trello values.
6. Enter this `e2e/` directory.
7. Start the development environment with `devenv shell`.

Do not put the credentials in a command argument or in a file.

## Commands

Create or check all resources:

```console
python3 accepted-artifact-issues/e2e.py setup
```

Create or check only the GitHub Projects resources:

```console
python3 accepted-artifact-issues/e2e.py setup --provider github-projects
```

Create or check only the Trello resources:

```console
python3 accepted-artifact-issues/e2e.py setup --provider trello
```

Create or check separate Trello planning and implementation boards:

```console
python3 accepted-artifact-issues/e2e.py setup --provider trello --trello-layout split
```

Run setup again with `--trello-layout single` to return generated configuration to one board. The
setup command keeps the unused board.

All setup selections need `GH_TOKEN` because each provider uses a GitHub repository. Only the
Trello selection needs the Trello credentials.

The Trello check supports Trello Free workspaces. It uses lists, descriptions, cards, and
checklists. It does not require or change Custom Fields.

Both providers use managed `artifact:<kind>` labels to show artifact types. The check preserves
labels that do not start with `artifact:`.

Run the two provider checks:

```console
python3 accepted-artifact-issues/e2e.py test
```

The default command attempts both providers. If one provider fails, the command checks the other
provider before it reports a nonzero exit status.

Run one provider check:

```console
python3 accepted-artifact-issues/e2e.py test --provider trello
```

Remove data after an interrupted check:

```console
python3 accepted-artifact-issues/e2e.py cleanup
```

The component keeps `.state.json` in its directory. This file contains resource identifiers and
URLs. It does not contain credentials. The component writes JSON result files to `results/`.

## Results

The check uses a unique feature name. It prints the URL for each pull request and workflow. It
stops if an assertion fails. It keeps failed resources for inspection.

After a successful check, the component closes the GitHub issues or archives the Trello cards.
It keeps the repositories, the GitHub Project, and the Trello board.
