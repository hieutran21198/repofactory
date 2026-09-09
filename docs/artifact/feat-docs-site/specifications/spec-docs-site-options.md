# spec-docs-site-options: Declare the docs-site composition option

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

A new composition sub-module declares the option `factory.composition.artifact-driven.docs-site`.
The option is off by default. A project sets the site values and can select a notification
provider. The module checks the domain selections and configured values with assertions.
The assertions add one invariant to the repository blueprint: a blueprint with the docs site has
the artifact-driven model, the multiple repositories architecture, and the `github-actions`
provider.

The module follows the `project-issues` precedent in
`services/factory/composition/artifact-driven/default.nix`: options, assertions, and files in
one `lib.mkIf` block.

## Contract

### Module path

```text
services/factory/composition/artifact-driven/docs-site/
├── default.nix
├── _assets/
└── tests/
    └── eval.nix
```

`libs/nix/_importer.nix` finds `default.nix` in each folder under `services/`. The module needs
no registration. The `_assets/` folder and the `tests/` folder have no `default.nix`, so the
importer does not load them as modules.

### Options

The module declares the options with the builders in `config.factory._utils`:

| Option | Builder | Type | Default | Meaning |
| --- | --- | --- | --- | --- |
| `factory.composition.artifact-driven.docs-site.enable` | `mkBoolOpt` | `bool` | `false` | Whether the factory renders the documentation site and its workflow. |
| `factory.composition.artifact-driven.docs-site.title` | `mkStrOpt` | `str` | `"Documentation"` | The title of the website. It is the browser title and the navbar title. |
| `factory.composition.artifact-driven.docs-site.url` | `mkStrOpt` | `str` | `""` | The origin of the website, for example `https://<owner>.github.io`. No path and no trailing `/`. |
| `factory.composition.artifact-driven.docs-site.base-url` | `mkStrOpt` | `str` | `"/"` | The path of the website under the origin, for example `/<repo>/` for a project site. It starts and ends with `/`. |
| `factory.composition.artifact-driven.docs-site.notification.provider` | `mkEnumOpt` | `"unset"`, `"google-chat"`, or `"slack"` | `"unset"` | The team webhook provider for deployment messages. |
| `factory.composition.artifact-driven.docs-site.notification.webhook-secret` | `mkStrOpt` | `str` | `"DOCS_SITE_NOTIFICATION_WEBHOOK"` | The GitHub Actions secret that contains the webhook URL. |

Example in `devenv.local.nix`:

```nix
factory.composition.artifact-driven.docs-site = {
  enable = true;
  title = "Repository factory";
  url = "https://example.github.io";
  base-url = "/repofactory/";
  notification = {
    provider = "google-chat";
    webhook-secret = "DOCS_SITE_NOTIFICATION_WEBHOOK";
  };
};
```

### Assertions

When `enable` is `true`, the module adds six site assertions. It adds one more assertion when a
notification provider is selected. The message is the exact string. `factory` is `namespace`.

| Condition | Message |
| --- | --- |
| `factory.domain.documentation.use == "artifact-driven"` | `factory.composition.artifact-driven.docs-site requires factory.domain.documentation.use = "artifact-driven"` |
| `factory.domain.repo-arch.use == "multiple"` | `factory.composition.artifact-driven.docs-site requires factory.domain.repo-arch.use = "multiple"` |
| `factory.domain.ci-cd.provider.use == "github-actions"` | `factory.composition.artifact-driven.docs-site requires factory.domain.ci-cd.provider.use = "github-actions"` |
| `builtins.match "https?://[^/]+" docs-site.url != null` | `factory.composition.artifact-driven.docs-site.url must be an origin such as https://owner.github.io` |
| `builtins.match "/|/.*/" docs-site.base-url != null` | `factory.composition.artifact-driven.docs-site.base-url must start and end with "/"` |
| `docs-site.title != ""` | `factory.composition.artifact-driven.docs-site.title must not be empty` |
| Notification is disabled, or `builtins.match "[A-Za-z_][A-Za-z0-9_]*" docs-site.notification.webhook-secret != null` | `factory.composition.artifact-driven.docs-site.notification.webhook-secret must be a GitHub secret name` |

`builtins.match` matches the whole string. The `url` condition accepts `https://example.github.io`
and `http://localhost:3000`. It rejects `""`, `example.github.io`, and
`https://example.github.io/`. The `base-url` condition accepts `/` and `/repo/`. It rejects
`repo`, `/repo`, and `repo/`.

### Disabled state

When `enable` is `false`, the module emits nothing:

| Output | Value |
| --- | --- |
| `files` | No entry from this module. |
| `assertions` | No entry from this module. |

The module does not read the three domain values when `enable` is `false`. A project without the
option has no site project and no docs-site workflow. The notification values do not enable the
documentation site.

## Errors

Nix evaluation stops with the message of the first false assertion when `enable` is `true`.
The message names the option and the required value.
Nix evaluation stops with a type error when a project sets `enable` to a value that is not a
boolean, or a string option to a value that is not a string. Evaluation also stops with a type
error for an unsupported notification provider.
The check `invalidSetupsRejected` in `tests/eval.nix` fails if one of the five invalid
configurations of `spec-eval-checks` has no false assertion.
The check `invalidNotificationSecretRejected` fails if an invalid enabled secret has no false
assertion.
The check `offEmitsNothing` fails if the module emits a file or an assertion when `enable` is
`false`.
