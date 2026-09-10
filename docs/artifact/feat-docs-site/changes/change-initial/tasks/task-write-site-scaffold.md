# task-write-site-scaffold: Write the site project assets

**Plan:** [Implementation plan](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, spec-docs-site-files, spec-docusaurus-config
**Context:** context-factory

## Goal

The folder `services/factory/composition/artifact-driven/docs-site/_assets/apps/documentation/`
holds the seven authored files of the site project with the content of `spec-docs-site-files`
and `spec-docusaurus-config`.

## Steps

1. Find the latest 3.9 patch release:
   `nix shell nixpkgs#nodejs_22 -c npm view @docusaurus/core@3.9 version`. Take the last
   version that the command prints.
2. Write `package.json` with the content of `spec-docs-site-files`: `name`, `private: true`,
   the four scripts, and the six dependencies. Set `@docusaurus/core` and
   `@docusaurus/preset-classic` to the same exact version of step 1, without `^` or `~`. Do not
   add a `type` field.
3. Run the lockfile command in the asset folder:

   ```sh
   cd services/factory/composition/artifact-driven/docs-site/_assets/apps/documentation
   nix shell nixpkgs#nodejs_22 -c npm install --package-lock-only --ignore-scripts
   ```

4. Write `docusaurus.config.js` in CommonJS. Start with `const site = require('./site.json');`.
   Set each setting of the table of `spec-docusaurus-config`, including `trailingSlash: true`,
   the five-entry `exclude` list, and `themeConfig.navbar.title: site.title`. End with
   `module.exports = config;`.
5. Add the `sidebarItemsGenerator` of `spec-docusaurus-config` to the `docs` options. Write
   `withIndexes(items, docs)` with the three cases of the table: relabel a category with a
   `doc` link from the title of that doc, and give a category without a `link` a
   `generated-index` link with `slug: '/' + folder`.
6. Write `sidebars.js`, `.gitignore`, `src/css/custom.css`, and `README.md` with the content
   of `spec-docs-site-files`. Write `README.md` in ASD-STE-100 with the four statements, in
   order. Do not add a status field.
7. Check the config text. Run this command in the asset folder. Each line of the output is `1`
   or more:

   ```sh
   for p in "trailingSlash: true" "site.json" "'../../docs'" "routeBasePath: '/'" \
     "format: 'detect'" "**/templates/**" "numberPrefixParser: false"; do
     grep -F -c -- "$p" docusaurus.config.js
   done
   ```

8. Check the two JSON files. Run this command in the asset folder:

   ```sh
   jq -r '.private, .type, .scripts.build, .dependencies."@docusaurus/core", .dependencies."@docusaurus/preset-classic"' package.json
   jq '.lockfileVersion' package-lock.json
   ```

9. Confirm that the asset folder has no `node_modules/` folder: `test ! -e node_modules`.
10. Run `git diff --check`.

## Check

Step 7 prints seven counts, each `1` or more. Step 8 prints `true`, `null`, `docusaurus build`,
and the same `3.9.<patch>` version two times, then a `lockfileVersion` of `2` or more. Step 9
exits 0. Step 10 reports no error. `node -e "require('./docusaurus.config.js')"` cannot run
in the asset folder, because `site.json` does not exist there; task 6 builds the site.
