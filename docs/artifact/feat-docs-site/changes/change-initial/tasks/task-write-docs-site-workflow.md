# task-write-docs-site-workflow: Write the docs-site workflow asset

**Plan:** [Implementation plan](README.md)
**Covers:** req-github-pages-publishing, spec-docs-site-workflow
**Context:** context-factory

## Goal

The asset `services/factory/composition/artifact-driven/docs-site/_assets/.github/workflows/docs-site.yml`
has the workflow of `spec-docs-site-workflow`.

## Steps

1. Write the file with the YAML of the `Workflow` block of `spec-docs-site-workflow`. Keep
   the trigger, the top-level `permissions`, the `concurrency` block, the `build` job, and the
   `deploy` job with the exact keys, values, and action versions.
2. Do not add a Nix interpolation. The module renders the file with `source`.
3. Check the text. Run this command from the repository root. Each line of the output is `1`
   or more:

   ```sh
   f=services/factory/composition/artifact-driven/docs-site/_assets/.github/workflows/docs-site.yml
   for p in "actions/upload-pages-artifact@v3" "actions/deploy-pages@v4" \
     "working-directory: apps/documentation" "npm ci" "pages: write" "id-token: write"; do
     grep -F -c -- "$p" "$f"
   done
   ```

4. Parse the YAML:
   `nix shell nixpkgs#yq-go -c yq '.jobs | keys' services/factory/composition/artifact-driven/docs-site/_assets/.github/workflows/docs-site.yml`.
5. Compare the `if` of the build job, the `needs` of the deploy job, and the `paths` list with
   `spec-docs-site-workflow`.
6. Run `git diff --check`.

## Check

Step 3 prints six counts, each `1` or more. Step 4 prints a list with `build` and `deploy` and
exits 0. Step 5 finds no difference. Step 6 reports no error.
