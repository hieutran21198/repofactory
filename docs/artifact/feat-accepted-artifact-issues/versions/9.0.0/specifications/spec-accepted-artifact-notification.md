# spec-accepted-artifact-notification: Deliver an acceptance summary

**Master:** [Specifications](README.md)
**Covers:** req-accepted-artifact-notification
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

Superseded by [spec-multiple-accepted-artifact-providers](spec-multiple-accepted-artifact-providers.md) for the provider selection and the secrets: the `notification.provider` option and the single webhook secret are replaced by `notification.uses` and one secret per provider. The result document, the message, and the delivery contract still apply.

## Configuration contract

The project issues composition has these notification options:

| Option | Type | Default |
| --- | --- | --- |
| `notification.provider` | `"unset"`, `"google-chat"`, or `"slack"` | `"unset"` |
| `notification.webhook-secret` | GitHub Actions secret name | `"ARTIFACT_NOTIFICATION_WEBHOOK"` |

`"unset"` disables notifications and does not add notification files or workflow steps. An enabled
provider requires a valid GitHub Actions secret name.

## Synchronization result

When `ARTIFACT_ISSUES_RESULT` has a path, the synchronizer writes a JSON document after successful
synchronization. The document has this structure:

```json
{
  "repository": "owner/repository",
  "pullRequest": {
    "number": 21,
    "title": "Accept feature artifacts",
    "url": "https://github.com/owner/repository/pull/21"
  },
  "artifacts": [
    {
      "change": "renamed",
      "path": "docs/artifact/feat-new/README.md",
      "previousPath": "docs/artifact/feat-old/README.md",
      "url": "https://tracker.example/artifact"
    }
  ]
}
```

The supported change values are `added`, `updated`, `renamed`, and `withdrawn`. The document lists
only files changed in the pull request. It does not list a parent that synchronization finds or
creates only to keep the hierarchy.

The synchronizer writes an empty `artifacts` list when no supported artifact changed. A manual scan
can write a result, but the workflow does not send it.

## Workflow contract

The generated notification step follows the synchronization step in the same job. It runs only for
`pull_request_target`. The normal step dependency prevents it from running after synchronization or
managed-comment failure.

The step gives the notifier these values:

- `ARTIFACT_ISSUES_RESULT`: The result document path in the runner temporary directory.
- `ARTIFACT_NOTIFICATION_PROVIDER`: The selected provider.
- `ARTIFACT_NOTIFICATION_WEBHOOK`: The configured GitHub Actions secret value.

The notifier sends no request for an empty artifact list. It fails if a nonempty result has no
webhook value.

## Message contract

Send one plain-text message for one pull request. Include the repository, pull request number and
title, pull request URL, and one line for each artifact change. Include both paths for a rename.
Include the project issue or Trello card URL for each artifact.

Keep the message at or below 3,500 characters. Keep complete artifact lines. If all lines do not
fit, add the number of omitted changes and keep the pull request URL as the complete reference.

Send `{"text": "..."}` as UTF-8 JSON. Do not print the webhook URL.

## Delivery contract

Treat each HTTP 2xx response as success. Retry a network error, HTTP 429, or HTTP 5xx response.
Make at most three attempts, with one-second and two-second delays. Do not retry another HTTP 4xx
response. Return a nonzero status after the final failure so that the workflow fails.

## Errors

- Stop Nix evaluation for an enabled provider with an invalid secret name.
- Stop notification delivery for an unsupported provider or invalid result document.
- Report the response status without reporting the webhook URL or response body.
