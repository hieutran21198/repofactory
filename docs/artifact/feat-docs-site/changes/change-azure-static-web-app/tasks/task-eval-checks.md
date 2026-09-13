# task-eval-checks: Extend the evaluation checks for both targets

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, spec-eval-checks
**Context:** context-factory

## Goal

Extend `tests/eval.nix` with target, provider, and assertion checks for both targets.

## Steps

1. Open `services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.
2. Add `target` and `azure-static-web-app.api-token-secret` to the `moduleFor` inputs.
3. Keep the current default and extension configurations unchanged.
4. Add configurations for the default target on both CI providers.
5. Add configurations for `azure-static-web-app` on both CI providers.
6. Add configurations for an invalid target and an invalid token secret name.
7. Check the `target` default `"github-pages"`.
8. Check the token secret default `"DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"`.
9. Check the Static Web App action name, task name, location inputs, and token mapping on both providers.
10. Check that each target emits no publish content of the other target.
11. Check that extension steps, `site.json` bytes, and notifications stay the same across targets.
12. Check that an invalid target gives a false assertion with a message that names both targets.
13. Check that an invalid token secret name gives a false assertion.
14. Keep all current file, dependency, notification, disabled-state, and domain-selection checks green.
15. Do not duplicate the Nix module system in the test stub.

## Check

Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.

- The command exits with status zero.
- All old assertions still pass.
- All new target assertions pass.

Run `python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py`.

- The command exits with status zero.
