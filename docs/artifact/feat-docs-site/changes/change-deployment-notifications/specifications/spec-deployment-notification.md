# spec-deployment-notification: Send a documentation site deployment message

**Master:** [Specifications](README.md)
**Covers:** req-deployment-notification
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Configuration contract

The documentation site composition has these notification options:

| Option | Type | Default |
| --- | --- | --- |
| `notification.provider` | `"unset"`, `"google-chat"`, or `"slack"` | `"unset"` |
| `notification.webhook-secret` | GitHub Actions secret name | `"DOCS_SITE_NOTIFICATION_WEBHOOK"` |

`"unset"` disables notifications. The factory generates no notifier or notification workflow
step. An enabled provider needs a valid GitHub Actions secret name.

The documentation site notification options do not use the accepted artifact notification
options. A project can select the same secret name for both functions.

## Generated files

| Generated path | Condition | Source |
| --- | --- | --- |
| `.github/workflows/docs-site.yml` | The documentation site is enabled. | Nix-rendered workflow text |
| `.github/docs-site/notify.py` | A notification provider is selected. | `./_assets/.github/docs-site/notify.py` |

Both files use copy mode. The module keeps the notifier out of the generated repository when the
provider is `"unset"`.

## Workflow contract

The deploy job keeps the `Deploy to GitHub Pages` step first. If notifications are enabled, these
steps follow it:

1. Check out the notification code with `actions/checkout@v4` and `persist-credentials: false`.
2. Run `python3 .github/docs-site/notify.py`.

The enabled deploy job adds `contents: read` to its job permissions. The notifier step gets these
environment values:

| Name | Value |
| --- | --- |
| `DOCS_SITE_NOTIFICATION_PROVIDER` | The selected provider. |
| `DOCS_SITE_NOTIFICATION_WEBHOOK` | `${{ secrets.<notification.webhook-secret> }}` |
| `DOCS_SITE_DEPLOYMENT_URL` | `${{ steps.deployment.outputs.page_url }}` |
| `DOCS_SITE_REPOSITORY` | `${{ github.repository }}` |
| `DOCS_SITE_REF_NAME` | `${{ github.ref_name }}` |
| `DOCS_SITE_COMMIT_SHA` | `${{ github.sha }}` |
| `DOCS_SITE_RUN_URL` | `${{ github.server_url }}/${{ github.repository }}/actions/runs/${{ github.run_id }}` |

Normal step order prevents the checkout and notification steps from running after a deployment
failure. The workflow sends a message after a successful default-branch push or manual run.

## Message contract

Send one plain-text message with this format:

```text
Documentation site deployed: owner/repository
URL: https://owner.github.io/repository/
Source: main @ 0123456
Run: https://github.com/owner/repository/actions/runs/123456
```

Use the first seven characters of the commit SHA. Keep the complete deployment URL and workflow
run URL. Keep the message at or below 3,500 characters.

Send `{"text": "..."}` as UTF-8 JSON. Do not print the webhook URL.

## Delivery contract

Treat each HTTP 2xx response as success. Retry a network error, HTTP 429, or HTTP 5xx response.
Make at most three attempts, with one-second and two-second delays. Do not retry another HTTP 4xx
response.

Return a nonzero status after the last failure. GitHub Pages keeps the deployed site, but GitHub
Actions reports a failed workflow. A workflow rerun can send a duplicate message.

## Errors

- Stop Nix evaluation for an enabled provider with an invalid secret name.
- Stop notification delivery for an unsupported provider or a missing message value.
- Report the response status without the webhook URL or response body.
