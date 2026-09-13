# task-target-options: Add the target and token secret options

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, spec-docs-site-options, spec-azure-static-web-app
**Context:** context-factory

## Goal

Add the publication target option and the token secret option with assertions in `default.nix`.

## Steps

1. Open `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Add option `target` with type `enum [ "github-pages", "azure-static-web-app" ]`.
3. Set the default of `target` to `"github-pages"`.
4. Add option `azure-static-web-app.api-token-secret` with type `str`.
5. Set the default of the token secret to `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"`.
6. Use the same string builder as the notification secrets for the token secret.
7. Add an assertion for a valid `target` when the site is on.
8. Name both targets in the error message of the assertion.
9. Add an assertion for a valid token secret name when `target` is `"azure-static-web-app"`.
10. Accept only names that match `[A-Za-z_][A-Za-z0-9_]*`.
11. Keep the default behavior for current projects with no target value.

## Check

Evaluate `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` with `nix-instantiate --eval --strict`.

- The default of `target` is `"github-pages"`.
- The default of the token secret is `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"`.
- An invalid target stops evaluation with a message that names both targets.
- An invalid token secret name stops evaluation when the target is `"azure-static-web-app"`.
