# spec-eval-checks: Check the docs-site module with a stub evaluation

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing
**Context:** context-factory

## Description

The check file `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` evaluates
the module with a stub `lib` and identity option builders. Each check is a named Boolean value.
The file asserts each check and exposes it in the result attribute set.

The checks read each source file with `builtins.readFile`. They read Nix-rendered files from the
`text` attribute. A text check uses `builtins.match` against the complete file.

## Configurations

The check evaluates these configurations:

| Name | Purpose |
| --- | --- |
| `on` | Enable the documentation site with notification disabled. |
| `googleChat` | Enable the site and select Google Chat. |
| `slack` | Enable the site, select Slack, and use `TEAM_WEBHOOK`. |
| `off` | Keep the documentation site disabled. |
| `single` | Use the unsupported single repository architecture. |
| `noCi` | Do not select GitHub Actions. |
| `noModel` | Do not select the artifact-driven documentation model. |
| `emptyUrl` | Use an empty site URL. |
| `badBaseUrl` | Use a base URL without its boundary slashes. |
| `invalidNotificationSecret` | Select Slack with `invalid-secret`. |

## Checks

The evaluation checks these groups:

- All base files exist and have the specified copy modes.
- Each authored source exists at its specified asset path.
- `site.json` has the configured values.
- The package and lockfile have the pinned dependency contract.
- The Docusaurus settings, Git ignore file, and wiki page have their required text.
- The base workflow has the build and GitHub Pages deployment steps.
- The notification option defaults and provider values match the public contract.
- The disabled configuration has no notifier or notification workflow step.
- The Google Chat and Slack configurations have the notifier and correct workflow values.
- The deployment step occurs before the notification checkout and notifier steps.
- The valid configurations pass their assertions.
- Each invalid configuration has a false assertion.
- The disabled site emits no file and no assertion.

## Python checks

The file `tests/test_notify.py` checks the deployment message and its required values. It sends
Google Chat and Slack payloads to a local HTTP server. It also checks retries, HTTP failures,
unsupported providers, the message limit, and safe errors.

## Commands

Run the module evaluation:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix
```

Run the notifier checks:

```sh
python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py
```

Run the parent composition evaluation after these checks. Each command exits with code zero when
all checks pass.

## Errors

Nix evaluation stops if a Boolean check is false or a source file does not exist. The Python check
command reports each failed test and exits with a nonzero code.
