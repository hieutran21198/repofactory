# task-user-guide: Document the manual Azure steps in the guide asset

**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-static-web-app, spec-azure-static-web-app
**Context:** context-factory

## Goal

Document the four manual Azure steps and the target option in the docs-site guide asset.

## Steps

1. Open `services/factory/composition/artifact-driven/docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md`.
2. Describe option `target` with values `github-pages` and `azure-static-web-app`.
3. State the default `github-pages` and the rule of exactly one target per site.
4. Describe option `azure-static-web-app.api-token-secret` and its default.
5. Document the four manual steps from `spec-azure-static-web-app`.
6. State that the owner creates one Static Web App resource in Azure.
7. State that the owner copies the deployment token of that resource.
8. State that the owner stores the token as a GitHub secret or an Azure secret variable with the configured secret name.
9. State that the owner marks the Azure variable as secret.
10. State that the owner sets the `url` and `base-url` options to the Static Web App address.
11. State that the factory cannot create the resource and cannot read the token.
12. Keep all current guide content for GitHub Pages, extensions, and notifications unchanged.

## Check

Evaluate `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` with `nix-instantiate --eval --strict`.

- The wiki page check passes with the new target and manual step content.
- All other checks still pass.

Read the rendered guide.

- A maintainer finds the target option, the token secret name, and the four manual steps.
