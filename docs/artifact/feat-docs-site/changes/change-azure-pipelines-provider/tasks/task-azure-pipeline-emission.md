# task-azure-pipeline-emission: Emit the Azure Pipelines pipeline

**Context:** context-factory
**Plan:** [Implementation plan](README.md)
**Covers:** req-azure-pipelines-publish, spec-docs-site-options, spec-docs-site-files, spec-docs-site-azure-pipeline, adr-shared-site-implementation, adr-azure-secret-mapping

## Goal

Emit the Azure pipeline in `services/factory` without a change to the GitHub Actions bytes.

## Steps

1. Accept `azure-pipelines` as a CI provider in `services/factory/composition/artifact-driven/docs-site/default.nix`.
2. Keep the shared step type and the three build hooks for both CI providers.
3. Keep the site project, the `site.json` bytes, and the notifier path identical on both CI providers.
4. Emit `azure-pipelines/docs-site.yml` only for `azure-pipelines`.
5. Emit `.github/workflows/docs-site.yml` only for `github-actions`.
6. Map the factory trigger paths first and then the configured watch paths.
7. Map each typed build step onto Azure syntax in list order.
8. Map each secret name one to one onto an Azure secret variable with the same name.
9. Reuse the same notifier script and the same message contract after deployment.
10. Extend the CI provider assertion and keep all other assertions for both providers.
11. Keep the `github-actions` output identical to version 4.0.3 with empty extension lists.

## Check

Run a Nix evaluation with CI provider `azure-pipelines` and show the Azure pipeline text.
Run a Nix evaluation with CI provider `github-actions` and show no change from version 4.0.3.
Show that the `site.json` bytes and the notifier bytes match on both CI providers.
