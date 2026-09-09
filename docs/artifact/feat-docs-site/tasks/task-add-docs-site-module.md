# task-add-docs-site-module: Add the docs-site composition module

**Plan:** [Implementation plan](README.md)
**Covers:** req-factory-owned-site, spec-docs-site-options, spec-docs-site-files
**Context:** context-factory

## Goal

The module `services/factory/composition/artifact-driven/docs-site/default.nix` declares the four
options, the six assertions, and the ten file entries, and emits nothing when the option is off.

## Steps

1. Make the folders `services/factory/composition/artifact-driven/docs-site/`,
   `docs-site/_assets/apps/documentation/src/css/`, `docs-site/_assets/.github/workflows/`,
   `docs-site/_assets/docs/wiki/documentation/artifact-driven/`, and `docs-site/tests/`.
   Tasks 2, 3, and 4 fill the `_assets/` folders.
2. Write `docs-site/default.nix` with the module signature of the parent module:
   `{ config, namespace, lib, ... }:` and `inherit (config.${namespace}) _utils;`.
3. Declare `options.${namespace}.composition.artifact-driven.docs-site` with the table of
   `spec-docs-site-options`: `enable` with `_utils.mkBoolOpt { default = false; }`, `title` with
   `_utils.mkStrOpt { default = "Documentation"; }`, `url` with `_utils.mkStrOpt { default = ""; }`,
   and `base-url` with `_utils.mkStrOpt { default = "/"; }`. Give each option a `description`.
4. In `config`, bind `docsSite = config.${namespace}.composition.artifact-driven.docs-site` and
   `inherit (config.${namespace}.domain) repo-arch documentation ci-cd;`.
5. Write `config` as one block `lib.mkIf docsSite.enable { assertions = [ ... ]; files = { ... }; }`.
   Do not read a domain value outside the block.
6. Add the six assertions with the exact conditions and messages of `spec-docs-site-options`.
   Use `${namespace}` in each message, as the `project-issues` assertions do.
7. Add the ten `files` entries of `spec-docs-site-files`. Use `source = ./_assets/<generated path>`
   for the nine authored files. Use
   `text = builtins.toJSON { title = docsSite.title; url = docsSite.url; baseUrl = docsSite.base-url; }`
   for `apps/documentation/site.json`. Set `copyMode = "copy"` on the eight copy files and
   `copyMode = "seed"` on `apps/documentation/src/css/custom.css` and
   `apps/documentation/README.md`.
8. Run `nix-instantiate --parse services/factory/composition/artifact-driven/docs-site/default.nix`.
9. Evaluate the module with the option off. Run this command from the repository root:

   ```sh
   nix-instantiate --eval --strict -E '
     (import ./services/factory/composition/artifact-driven/docs-site/default.nix {
       lib.mkIf = condition: value: if condition then value else { };
       namespace = "factory";
       config.factory = {
         _utils = { mkBoolOpt = x: x; mkStrOpt = x: x; };
         domain = {
           documentation.use = "artifact-driven";
           repo-arch.use = "multiple";
           ci-cd.provider.use = "github-actions";
         };
         composition.artifact-driven.docs-site = {
           enable = false; title = "Documentation"; url = ""; base-url = "/";
         };
       };
     }).config'
   ```

10. Compare each option name, default, condition, and message with `spec-docs-site-options`.
    Compare each file path, source, and `copyMode` with the table of `spec-docs-site-files`.
11. Run `git diff --check`.

## Check

Step 8 prints the parsed expression and exits 0. Step 9 prints `{ }` and exits 0: the module
emits no file and no assertion when `enable` is `false`. Step 10 finds no difference. Step 11
reports no error. An evaluation with `enable = true` fails until tasks 2, 3, and 4 add the
asset files; task 5 makes that evaluation.
