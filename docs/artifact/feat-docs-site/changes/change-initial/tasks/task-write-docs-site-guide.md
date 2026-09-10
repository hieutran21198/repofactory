# task-write-docs-site-guide: Write the docs-site wiki page

**Plan:** [Implementation plan](README.md)
**Covers:** req-browsable-docs, req-github-pages-publishing, req-factory-owned-site, spec-docs-site-files
**Context:** context-factory

## Goal

The asset
`services/factory/composition/artifact-driven/docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md`
tells a project how to run, publish, and write for the documentation site.

## Steps

1. Write the page in ASD-STE-100 with the `asd-ste-100` skill. Start with a title and one
   paragraph that says what the site is: the website renders the `docs/` tree, the factory
   renders the site project at `apps/documentation/`, and the project sets the options
   `factory.composition.artifact-driven.docs-site` in `devenv.local.nix`.
2. Write the section `## Run locally`. Say that Node.js 22 is not in the shell. Give the two
   ways to get it: `languages.javascript = { enable = true; npm.enable = true; }` in
   `devenv.local.nix`, or `nix shell nixpkgs#nodejs_22`. Then give the three commands
   `cd apps/documentation`, `npm ci`, and `npm run start`.
3. Write the section `## Publish`. Say that the workflow `.github/workflows/docs-site.yml`
   builds and publishes the site on each push to the default branch. Give the one manual step:
   in the repository settings, under Pages, set the source to "GitHub Actions". Say that a
   push to another branch and a failed build keep the published site.
4. Write the section `## Write pages that render`. Give these rules:
   - A `.md` file renders as CommonMark. Put a `<name>` placeholder in backticks or in a code
     block.
   - Link a `README.md` file, not a folder. The link `](decisions/README.md)` opens the index
     page of the folder.
   - A link to a URL path of a folder must end with `/`, for example `](decisions/)`. Without
     the `/`, the browser resolves the link in the parent folder.
   - The templates under `docs/wiki/**/templates/` do not render.
5. Do not add a status field or a phase field.
6. Check the text. Run this command from the repository root. Each line of the output is `1`
   or more:

   ```sh
   f=services/factory/composition/artifact-driven/docs-site/_assets/docs/wiki/documentation/artifact-driven/docs-site.md
   for p in "npm run start" "GitHub Actions" "## Run locally" "## Publish" "## Write pages that render"; do
     grep -F -c -- "$p" "$f"
   done
   ```

7. Run `git diff --check`.

## Check

Step 6 prints five counts, each `1` or more. The three headings are in the order of step 6.
Step 7 reports no error.
