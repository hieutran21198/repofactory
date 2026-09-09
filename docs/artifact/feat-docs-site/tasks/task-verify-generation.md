# task-verify-generation: Verify the generated site in this repository

**Plan:** [Implementation plan](README.md)
**Covers:** req-browsable-docs, req-github-pages-publishing, req-factory-owned-site, spec-docs-site-options, spec-docs-site-files, spec-docusaurus-config, spec-docs-site-workflow, spec-eval-checks
**Context:** context-factory

## Goal

The site renders in this repository from the option alone, the build has the expected pages,
and a second shell entry regenerates the copy files and keeps the seed files.

## Steps

1. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`.
2. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
3. Add the option to `devenv.local.nix` of this repository. The file is in `.gitignore`.

   ```nix
   factory.composition.artifact-driven.docs-site = {
     enable = true;
     url = "https://<owner>.github.io";
     base-url = "/repofactory/";
   };
   ```

   Replace `<owner>` with the GitHub owner of this repository.
4. Enter the shell with `devenv shell`, or reload direnv. List the ten files of
   `spec-docs-site-files`. Read `apps/documentation/site.json` and confirm the title
   `Documentation`, the URL, and the base URL.
5. Add one line to `apps/documentation/README.md` and one comment to
   `apps/documentation/src/css/custom.css`. Add one line to `apps/documentation/sidebars.js`.
   Enter the shell again. Confirm that `README.md` and `custom.css` keep the added lines and
   that `sidebars.js` is the asset again. Then remove the added lines from the two seed files.
6. Run the build:

   ```sh
   cd apps/documentation && nix shell nixpkgs#nodejs_22 -c sh -c 'npm ci && npm run build'
   ```

7. Confirm that these files exist under `apps/documentation/build/`: `index.html`,
   `artifact/feat-ddd-design/index.html`, and `artifact/feat-ddd-design/decisions/index.html`.
8. Confirm that `apps/documentation/build/wiki/documentation/artifact-driven/templates/` and
   `apps/documentation/build/wiki/design/ddd/templates/` do not exist.
9. Confirm that `apps/documentation/build/wiki/documentation/artifact-driven/index.html`
   contains the text `feat-<name>/` from the indented code block of the source page.
10. Read the output of `npm run build`. List each broken-link warning. For each warning, find
    the source page and the target. Report the list. Do not change a page in this task.
11. Optional: run `npm run serve` in `apps/documentation` and open the home page, the page of
    `feat-ddd-design`, and its `Decisions` link in a browser.
12. Run `git diff --check`.
13. Run `git status`. Confirm that `apps/documentation/node_modules/`, `build/`, and
    `.docusaurus/` are not in the list, and that `devenv.local.nix` is not in the list.

## Check

Steps 1 and 2 exit 0 and print each check as `true`. Step 4 lists the ten files, and
`site.json` has the three configured values. Step 5 shows the seed files with the added lines
and `sidebars.js` without the added line. Step 6 exits 0. Step 7 finds the three files. Step 8
finds no templates folder. Step 9 finds the text. Step 10 gives a list of warnings, each with a
source page and a target; the list has no warning for a link to `README.md` or to a
`decisions/` or `changes/` folder. Step 12 reports no error. Step 13 lists only the intended
source changes under `services/factory/` and the rendered files under `apps/documentation/`,
`.github/workflows/`, and `docs/wiki/documentation/artifact-driven/`.
