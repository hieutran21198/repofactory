# spec-artifact-type-labels: Manage provider type labels

**Master:** [Specifications](README.md)
**Covers:** req-artifact-type-labels
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Label model

Each artifact kind maps to a label named `artifact:<kind>`. These are the managed labels:

- `artifact:feature-summary`
- `artifact:master-requirement`
- `artifact:requirement`
- `artifact:master-specification`
- `artifact:specification`
- `artifact:decision`
- `artifact:implementation-plan`
- `artifact:task`
- `artifact:change-summary`

Repofactory owns labels whose names start with `artifact:`. It does not change other labels.

The provider adapters contain one fixed color map. GitHub uses hexadecimal colors. Trello uses
the nearest available named colors. A label name, not its color, identifies a managed label.

## GitHub contract

Preflight reads the repository labels. It creates each missing managed label through the GitHub
Labels API.

Upsert keeps all labels without the `artifact:` prefix. It adds the label for the current artifact
kind. It removes other managed type labels. Withdraw keeps the current type label.

The backing repository issue supplies labels to the GitHub Project `Labels` field. The project
`Status` field continues to represent status.

## Trello contract

Preflight reads the board labels. It creates each missing managed label through the Trello Labels
API.

Upsert keeps all labels without the `artifact:` prefix. It adds the board label for the current
artifact kind. It removes other managed type labels. Withdraw keeps the current type label.

The configured Trello list continues to represent status. The card description and `Children`
checklist continue to represent metadata and hierarchy.

## End-to-end contract

Setup can reuse existing managed labels. The inspector verifies the exact managed type label on
each item. The inspector also verifies that a test user label stays after an update.

The lifecycle checks create, rerun, update, rename, withdraw, and cleanup behavior in both
providers.

## Errors

- Stop the provider synchronization if a managed label name is not unique.
- Stop the provider synchronization if the provider rejects a label operation.
- Do not remove an unrelated label after a managed label error.
