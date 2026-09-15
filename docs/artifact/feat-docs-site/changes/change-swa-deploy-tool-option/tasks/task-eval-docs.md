# task-eval-docs: Check the deploy shapes and document the option

**Plan:** [Implementation plan](README.md)
**Covers:** spec-swa-deploy-tool, spec-swa-cli-deploy
**Context:** context-factory

## Goal

Check both deploy tools on both CI providers and document the option for repository maintainers.

## Files

- `services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
- `services/factory/composition/artifact-driven/docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md`
- `docs/wiki/documentation/artifact-driven/docs-site.md`

## Steps

1. Add a `deployTool` input to the `moduleFor` test helper.
2. Set `azure-static-web-app.deploy-tool` from that input.
3. Add configurations for the default and both explicit tool values on both CI providers.
4. Add `github-pages` configurations that set `swa-cli` on both CI providers.
5. Add an invalid deploy tool configuration.
6. Check the option enum values, the default, and the absence of a CLI version option.
7. Check exactly one deploy shape for each tool selection on each CI provider.
8. Check that the default selection has the version 6.1.0 official deploy shape.
9. Check the package pin, installation command, deploy command, output path, and production environment.
10. Check the GitHub and Azure token mappings without exposing a token value.
11. Check the existing GitHub npm cache inputs.
12. Check the Azure cache variable, task inputs, cache key, restore keys, and task order.
13. Check the build-hook, installation, deployment, and notification order on both providers.
14. Check that notifications keep the same content for both deploy tools.
15. Check that `github-pages` emits no Static Web App deploy content for either tool value.
16. Check that the invalid value produces a false assertion and the specified error message.
17. Keep all existing docs-site evaluation checks.
18. Document `azure-static-web-app.deploy-tool`, its values, and its default in the guide asset.
19. Document the factory-owned CLI pin, cache behavior, common deploy result, and unchanged notifications.
20. State that a project cannot configure the CLI version.
21. Copy the guide change to the canonical `docs/wiki` page.
22. Keep the guide asset and the canonical page byte-for-byte equal.

## Check

Run these commands:

1. `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`
2. `python3 -m unittest services/factory/composition/artifact-driven/docs-site/tests/test_notify.py`
3. `cmp services/factory/composition/artifact-driven/docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md docs/wiki/documentation/artifact-driven/docs-site.md`
4. `git diff --check`

Each command must exit with status zero. The Nix result must expose a true Boolean for each new check.

## Errors

- An invalid deploy tool check must fail if evaluation accepts the value.
- The Nix command must stop if a deploy shape, cache value, token mapping, or step order is wrong.
- The file comparison must fail if the two guide files differ.
